module Shared::HeroBackground
  BASE_CLASSES = [
    "hero-bg",
    "relative",
    "isolate",
    "overflow-hidden",
    "before:pointer-events-none",
    "before:absolute",
    "before:inset-0",
    "before:z-[-1]",
    "before:bg-cover",
    "before:bg-no-repeat",
    "before:opacity-[0.22]",
    "before:content-['']"
  ].freeze

  POSITIONS = {
    center: "before:bg-center",
    train: "before:bg-[60%_65%]"
  }.freeze

  def self.classes(position: :center)
    (BASE_CLASSES + [POSITIONS.fetch(position)]).join(" ")
  end

  CLASSES = classes(position: :center).freeze
  COLLECTION_HEADER_CLASSES = classes(position: :train).freeze
end
