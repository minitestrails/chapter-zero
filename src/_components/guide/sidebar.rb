class Guide::Sidebar < Bridgetown::Component
  def initialize(guide_resources:, current_url:, guide_index_url:)
    @guide_resources = guide_resources
    @current_url = current_url
    @guide_index_url = guide_index_url
  end
end
