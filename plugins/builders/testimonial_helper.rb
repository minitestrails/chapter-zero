class Builders::TestimonialHelper < SiteBuilder
  def build
    helper :testimonial_data
  end

  def testimonial_data(testimonial)
    entry = testimonial.respond_to?(:to_h) ? testimonial.to_h : testimonial
    entry = entry.transform_keys(&:to_s)

    feedback_html = ERB::Util.html_escape(entry["feedback"].to_s)
    Array(entry["highlighted_text"]).each do |phrase|
      next if phrase.to_s.empty?

      escaped_phrase = ERB::Util.html_escape(phrase.to_s)
      feedback_html = feedback_html.gsub(
        escaped_phrase,
        %(<span class="testimonial-highlight">#{escaped_phrase}</span>)
      )
    end

    name_parts = entry["name"].to_s.strip.split(/\s+/)
    initials = if name_parts.empty?
      "?"
    elsif name_parts.length >= 2
      "#{name_parts[0][0]}#{name_parts[1][0]}".upcase
    else
      name_parts[0][0..1].upcase
    end

    raw_image = (entry["image_path"] || entry["image_url"]).to_s.strip
    image_src = if raw_image == ""
      ""
    elsif raw_image.start_with?("http")
      raw_image
    else
      helpers.relative_url(raw_image)
    end

    {
      entry: entry,
      feedback_html: feedback_html.html_safe,
      initials: initials,
      image_src: image_src
    }
  end
end
