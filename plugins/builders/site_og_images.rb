require "cgi"
require "json"
require "tempfile"
require "fileutils"
require "thread"

# Guide and blog OG cards share one background scaled once per build to
# output/og/_background-1200x630.png, then referenced from each SVG (no base64
# embed). PNGs land in output/og/guide/ and output/og/blog/. Requires ImageMagick
# (`magick` or `convert`) and `rsvg-convert` on PATH.
module SiteOgImage
  module_function

  WIDTH = 1200
  HEIGHT = 630
  MARGIN_X = 80
  MARGIN_RIGHT = 80
  TEXT_MUTED = "#a0aec0"
  TEXT_TITLE = "#ffffff"
  TEXT_DESC = "#cbd5e0"

  CHAPTER_Y = 118
  TITLE_START_Y = 178
  TITLE_LINE_DY = 58
  DESC_GAP_Y = 20
  DESC_FONT = 20
  DESC_LINE_DY = 28
  DOMAIN_BASELINE_Y = HEIGHT - 36
  FOOTER_FONT = 14
  CACHED_BACKGROUND_NAME = "_background-1200x630.png"
  BACKGROUND_SVG_NAME = "og-background.png"
  BACKGROUND_FILL = "#1a202c"
  # Matches landing hero / collection header (.hero-bg::before opacity)
  BACKGROUND_OPACITY = 0.22

  def default_background_path(root_dir: nil)
    candidates = []
    candidates << File.join(root_dir, "src", "images", "blog-og-background.png") if root_dir
    candidates << File.expand_path("../../../src/images/blog-og-background.png", __dir__)
    candidates.find { |path| File.file?(path) }
  end

  def cached_background_path(cache_dir)
    File.join(cache_dir, CACHED_BACKGROUND_NAME)
  end

  def imagemagick_command
    @imagemagick_command ||=
      %w[magick convert].find do |cmd|
        system(cmd, "-version", out: File::NULL, err: File::NULL)
      end
  end

  def ensure_cached_background(source_path:, cache_path:)
    raise "OG background not found: #{source_path}" unless source_path && File.file?(source_path)

    FileUtils.mkdir_p(File.dirname(cache_path))
    source_mtime = File.mtime(source_path)
    if File.file?(cache_path) && File.mtime(cache_path) >= source_mtime
      return cache_path
    end

    cmd = imagemagick_command
    unless cmd
      raise "ImageMagick not found (need magick or convert on PATH)"
    end

    ok =
      system(
        cmd,
        source_path,
        "-resize",
        "#{WIDTH}x#{HEIGHT}^",
        "-gravity",
        "center",
        "-extent",
        "#{WIDTH}x#{HEIGHT}",
        "-strip",
        cache_path
      )
    unless ok && File.file?(cache_path) && File.size(cache_path).positive?
      raise "#{cmd} failed to scale OG background"
    end

    cache_path
  end

  def domain_display_from_url(url)
    url.to_s.sub(%r{\Ahttps?://}i, "").sub(%r{/\z}, "")
  end

  def label_for_resource(collection_label:, data:)
    case collection_label.to_s
    when "guide"
      order = data["order"]
      order = order.nil? ? 0 : order.to_i
      "CHAPTER #{format("%02d", order)}"
    when "blog"
      blog_label_from_date(data["date"])
    else
      ""
    end
  end

  def blog_label_from_date(date)
    return "BLOG" if date.nil?

    parsed =
      if date.respond_to?(:strftime)
        date
      else
        require "date"
        Date.parse(date.to_s)
      end
    parsed.strftime("%b %d, %Y").upcase
  rescue StandardError
    "BLOG"
  end

  def png_bytes(
    domain_display:,
    description: "",
    cached_background_path:,
    brand_footer: "",
    title: nil,
    label: nil,
    chapter_title: nil,
    chapter_order: nil
  )
    card_title = (title || chapter_title).to_s.strip
    card_title = card_title[0, 160] if card_title.length > 160
    card_label =
      if !label.to_s.strip.empty?
        label.to_s
      elsif !chapter_order.nil?
        "CHAPTER #{format("%02d", chapter_order.to_i)}"
      else
        ""
      end

    svg =
      svg_document(
        title: card_title,
        label: card_label,
        domain_display: domain_display.to_s,
        description: description.to_s,
        brand_footer: brand_footer.to_s.upcase,
        use_background: !cached_background_path.to_s.empty?
      )
    rsvg_rasterize(svg, background_file: cached_background_path)
  end

  def truncate_description(text, max_chars: 200)
    t = text.strip.gsub(/\s+/, " ")
    return t if t.length <= max_chars

    cut = t[0, max_chars]
    idx = cut.rindex(" ")
    cut = idx&.positive? ? cut[0, idx] : cut
    "#{cut}..."
  end

  # Word-wrap to lines of at most max_chars; at most max_lines lines.
  def wrap_lines(text, max_chars:, max_lines:)
    words = text.to_s.split(/\s+/).reject(&:empty?)
    lines = []
    buf = +""

    flush =
      lambda do
        return if buf.empty?

        # Push a copy: `lines << buf` then `buf.clear` would mutate the same string
        # already stored in `lines`, leaving empty placeholders.
        lines << buf.dup
        buf.clear
      end

    words.each do |word|
      trial = buf.empty? ? word : "#{buf} #{word}"
      if trial.length <= max_chars
        buf = trial
      elsif buf.empty?
        lines << word[0, max_chars]
        return lines[0, max_lines] if lines.length >= max_lines

        rest = word[max_chars..].to_s.strip
        buf = rest
      else
        flush.call
        return lines[0, max_lines] if lines.length >= max_lines

        buf = word
      end
    end

    flush.call
    lines[0, max_lines]
  end

  def escape_xml(text)
    CGI.escapeHTML(text)
  end

  def svg_document(
    title:,
    label:,
    domain_display:,
    description: "",
    brand_footer: "",
    use_background: false
  )
    label_text = label.to_s.strip
    # ~18 chars per line fits the 56px title in the left column (see wrap_lines tuning).
    title_lines = wrap_lines(title, max_chars: 18, max_lines: 5)
    desc_raw = truncate_description(description)
    desc_lines =
      (
        if desc_raw.strip.empty?
          []
        else
          wrap_lines(desc_raw, max_chars: 54, max_lines: 3)
        end
      )
    domain = domain_display.strip.downcase

    ff = "sans-serif"
    body = +""
    y = CHAPTER_Y
    body << text_line(
      x: MARGIN_X,
      y: y,
      font_family: ff,
      font_size: 14,
      font_weight: "600",
      fill: TEXT_MUTED,
      text: label_text,
      anchor: "start",
      letter_spacing: "0.2em"
    )
    y = TITLE_START_Y
    title_lines.each do |line|
      body << text_line(
        x: MARGIN_X,
        y: y,
        font_family: ff,
        font_size: 56,
        font_weight: "700",
        fill: TEXT_TITLE,
        text: line,
        anchor: "start"
      )
      y += TITLE_LINE_DY
    end
    unless desc_lines.empty?
      y += DESC_GAP_Y
      desc_lines.each do |line|
        body << text_line(
          x: MARGIN_X,
          y: y,
          font_family: ff,
          font_size: DESC_FONT,
          font_weight: "400",
          fill: TEXT_DESC,
          text: line,
          anchor: "start"
        )
        y += DESC_LINE_DY
      end
    end
    body << text_line(
      x: MARGIN_X,
      y: DOMAIN_BASELINE_Y,
      font_family: ff,
      font_size: FOOTER_FONT,
      font_weight: "400",
      fill: TEXT_MUTED,
      text: domain,
      anchor: "start"
    )
    body << text_line(
      x: WIDTH - MARGIN_RIGHT,
      y: DOMAIN_BASELINE_Y,
      font_family: ff,
      font_size: FOOTER_FONT,
      font_weight: "600",
      fill: TEXT_MUTED,
      text: brand_footer,
      anchor: "end",
      letter_spacing: "0.14em"
    )

    <<~SVG
      <?xml version="1.0" encoding="UTF-8"?>
      <svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="#{WIDTH}" height="#{HEIGHT}" viewBox="0 0 #{WIDTH} #{HEIGHT}">
        #{background_layer(use_background)}
        #{body}
      </svg>
    SVG
  end

  def background_layer(use_background)
    base = %(<rect width="#{WIDTH}" height="#{HEIGHT}" fill="#{BACKGROUND_FILL}"/>\n)
    return base unless use_background

    base +
      %(<image href="#{BACKGROUND_SVG_NAME}" x="0" y="0" width="#{WIDTH}" height="#{HEIGHT}" opacity="#{BACKGROUND_OPACITY}"/>\n)
  end

  def rsvg_rasterize(svg, background_file: nil)
    png_bytes = nil
    Dir.mktmpdir("site-og") do |dir|
      svg_path = File.join(dir, "card.svg")
      png_path = File.join(dir, "card.png")
      File.write(svg_path, svg)
      if background_file && File.file?(background_file)
        link_path = File.join(dir, BACKGROUND_SVG_NAME)
        begin
          File.link(background_file, link_path)
        rescue Errno::EXDEV, Errno::ENOENT, Errno::EPERM, NotImplementedError
          FileUtils.cp(background_file, link_path)
        end
      end
      ok =
        system(
          "rsvg-convert",
          "-w",
          WIDTH.to_s,
          "-h",
          HEIGHT.to_s,
          svg_path,
          "-o",
          png_path,
          out: File::NULL,
          err: File::NULL
        )
      unless ok && File.file?(png_path) && File.size(png_path).positive?
        raise "rsvg-convert failed or produced empty output"
      end

      png_bytes = File.binread(png_path)
    end
    png_bytes
  end

  def text_line(
    x:,
    y:,
    font_family:,
    font_size:,
    font_weight:,
    fill:,
    text:,
    anchor: "start",
    letter_spacing: nil
  )
    return +"" if text.to_s.strip.empty?

    spacing =
      letter_spacing ? %( letter-spacing="#{escape_xml(letter_spacing)}") : ""
    %(<text x="#{x}" y="#{y}" text-anchor="#{anchor}"#{spacing} font-family="#{font_family}" font-size="#{font_size}" font-weight="#{font_weight}" fill="#{fill}">#{escape_xml(text)}</text>\n)
  end
end

Bridgetown::Hooks.register_one :resources,
                               :post_read,
                               reloadable: false do |resource|
  collection_label = resource.collection&.label.to_s
  next unless %w[guide blog].include?(collection_label)

  slug = resource.data["slug"].to_s
  next if slug.empty?

  img = resource.data["image"]
  if img.is_a?(Hash) && img["path"].to_s.strip != ""
    next
  elsif img.is_a?(String) && img.strip != ""
    next
  end

  resource.data["image"] = {
    "path" => "/og/#{collection_label}/#{slug}.png",
    "alt" => resource.data["title"].to_s,
    # Facebook / LinkedIn use these for correct aspect ratio in the crawler.
    "width" => SiteOgImage::WIDTH,
    "height" => SiteOgImage::HEIGHT
  }
end

class Builders::SiteOgImages < Bridgetown::Generator
  priority :low

  OG_COLLECTIONS = %w[guide blog].freeze

  def generate(site)
    domain = SiteOgImage.domain_display_from_url(site.config.url)
    brand_footer = (site.data.site_metadata&.title || site.config.title || "Chapter Zero").to_s
    background_source =
      SiteOgImage.default_background_path(root_dir: site.root_dir)
    og_dir = site.in_dest_dir("og")
    cached_background =
      SiteOgImage.ensure_cached_background(
        source_path: background_source,
        cache_path: SiteOgImage.cached_background_path(og_dir)
      )
    background_mtime = File.mtime(cached_background)

    OG_COLLECTIONS.each do |collection_label|
      generate_collection_og_images(
        site: site,
        collection_label: collection_label,
        domain: domain,
        brand_footer: brand_footer,
        cached_background: cached_background,
        background_mtime: background_mtime
      )
    end
  end

  def generate_collection_og_images(
    site:,
    collection_label:,
    domain:,
    brand_footer:,
    cached_background:,
    background_mtime:
  )
    collection =
      site.collections[collection_label.to_sym] ||
        site.collections[collection_label] ||
        site.collections.values.find { |c| c.label.to_s == collection_label }
    unless collection
      Bridgetown.logger.warn(
        "SiteOgImages:",
        %(Collection "#{collection_label}" not found; skipping OG PNGs.)
      )
      return
    end

    out_dir = site.in_dest_dir("og", collection_label)
    FileUtils.mkdir_p(out_dir)

    manifest = {}
    jobs = []
    errors = []
    errors_mutex = Mutex.new

    collection.resources.each do |resource|
      slug = resource.data["slug"].to_s
      next if slug.empty?

      title = resource.data["title"].to_s
      description = resource.data["description"].to_s
      label =
        SiteOgImage.label_for_resource(
          collection_label: collection_label,
          data: resource.data
        )
      manifest[slug] = {
        "title" => title,
        "description" => description,
        "label" => label
      }

      png_path = File.join(out_dir, "#{slug}.png")
      source_path = resource.path.to_s
      source_mtime =
        if source_path != "" && File.file?(source_path)
          File.mtime(source_path)
        else
          0
        end
      png_mtime = File.file?(png_path) ? File.mtime(png_path) : nil
      next if png_mtime && png_mtime >= background_mtime && png_mtime >= source_mtime

      jobs << {
        slug: slug,
        title: title,
        description: description,
        label: label,
        png_path: png_path
      }
    end

    worker_count = [jobs.length, 4].min
    if worker_count.positive?
      queue = Queue.new
      jobs.each { |job| queue << job }
      worker_count.times { queue << :done }

      threads =
        Array.new(worker_count) do
          Thread.new do
            loop do
              job = queue.pop
              break if job == :done

              png =
                SiteOgImage.png_bytes(
                  title: job[:title],
                  label: job[:label],
                  domain_display: domain,
                  description: job[:description],
                  brand_footer: brand_footer,
                  cached_background_path: cached_background
                )
              File.binwrite(job[:png_path], png)
            rescue StandardError => e
              errors_mutex.synchronize do
                errors << [collection_label, job[:slug], e.message]
              end
            end
          end
        end
      threads.each(&:join)
    end

    errors.each do |collection_name, slug, message|
      Bridgetown.logger.error(
        "SiteOgImages:",
        "Failed for #{collection_name}/#{slug}: #{message}"
      )
    end

    File.write(
      File.join(out_dir, "manifest.json"),
      JSON.pretty_generate(manifest)
    )
  end
end
