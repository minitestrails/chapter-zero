class Routes::OgImage < Bridgetown::Rack::Routes
  priority :highest

  BUILT_PNG_HEADERS = {
    "Content-Type" => "image/png",
    "Cache-Control" => "public, max-age=86400, immutable"
  }.freeze

  DYNAMIC_PNG_HEADERS = {
    "Content-Type" => "image/png",
    "Cache-Control" => "public, max-age=120"
  }.freeze

  OG_COLLECTIONS = %w[guide blog].freeze

  route do |r|
    r.get "og", String, String do |collection, file|
      next unless OG_COLLECTIONS.include?(collection)
      next unless file =~ /\A([\w-]+)\.png\z/

      slug = ::Regexp.last_match(1)
      cfg = Bridgetown::Current.preloaded_configuration
      next unless cfg

      dest = File.join(cfg.root_dir, cfg.destination)
      png_path = File.join(dest, "og", collection, "#{slug}.png")

      if File.file?(png_path) && File.size(png_path).positive?
        r.halt [200, BUILT_PNG_HEADERS, [File.binread(png_path)]]
      end

      manifest_path = File.join(dest, "og", collection, "manifest.json")
      if File.file?(manifest_path)
        manifest = JSON.parse(File.read(manifest_path))
        entry = manifest[slug]
        if entry
          begin
            domain = SiteOgImage.domain_display_from_url(cfg.url)
            background_source =
              SiteOgImage.default_background_path(root_dir: cfg.root_dir)
            cached_background =
              SiteOgImage.ensure_cached_background(
                source_path: background_source,
                cache_path:
                  SiteOgImage.cached_background_path(
                    File.join(dest, "og")
                  )
              )
            label = entry["label"].to_s
            if label.empty? && entry["order"]
              label =
                "CHAPTER #{format("%02d", entry["order"].to_i)}"
            end
            brand_footer =
              begin
                Bridgetown::Current.site.data.site_metadata.title.to_s
              rescue StandardError
                "Chapter Zero"
              end
            body =
              SiteOgImage.png_bytes(
                title: entry["title"].to_s,
                label: label,
                domain_display: domain,
                description: entry["description"].to_s,
                brand_footer: brand_footer,
                cached_background_path: cached_background
              )
            r.halt [200, DYNAMIC_PNG_HEADERS, [body]]
          rescue StandardError
            # fall through
          end
        end
      end

      fallback = File.join(dest, "images", "og-image.png")
      if File.file?(fallback) && File.size(fallback).positive?
        r.halt [200, BUILT_PNG_HEADERS, [File.binread(fallback)]]
      end
    end
  end
end
