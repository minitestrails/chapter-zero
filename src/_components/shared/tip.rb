require "kramdown"
require "kramdown-parser-gfm"

class Shared::Tip < Bridgetown::Component
  def initialize(title: "Tip", markdown: nil, html: nil)
    @title = title.to_s
    @markdown = markdown
    @html = html
  end

  def body_html
    fragment =
      if @html
        @html.to_s
      elsif !@markdown.to_s.strip.empty?
        Kramdown::Document.new(@markdown.to_s.strip, input: "GFM").to_html
      else
        ""
      end

    fragment.html_safe
  end
end
