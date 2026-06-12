class Shared::Badge < Bridgetown::Component
  def initialize(text:, classes: "")
    @text = text.to_s
    @html_classes = classes.to_s.strip
  end

  def badge_classes
    ["badge", @html_classes].reject(&:empty?).join(" ")
  end
end
