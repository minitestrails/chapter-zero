class Shared::SupportBanner < Bridgetown::Component
  def support_url
    @support_url ||= helpers.support_url
  end

  def render?
    !support_url.nil?
  end
end
