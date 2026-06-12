class Shared::Button < Bridgetown::Component
  def initialize(text:, classes: "", href: nil, type: nil)
    @text = text.to_s
    @html_classes = classes.to_s.strip
    @href = href&.to_s
    @type = type&.to_s
  end

  def button_classes
    ["btn", @html_classes].reject(&:empty?).join(" ")
  end

  def link?
    !@href.to_s.strip.empty?
  end

  def external_href?
    @href.to_s.start_with?("http://", "https://", "mailto:", "tel:", "#")
  end
end
