class Shared::CollectionHeader < Bridgetown::Component
  def initialize(title:, description:)
    @title = title
    @description = description
  end
end
