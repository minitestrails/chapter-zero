class Guide::ComingSoon < Bridgetown::Component
  DEFAULT_MESSAGE =
    "This chapter is not out yet. We are publishing new chapters over time."
  DEFAULT_NEWSLETTER_HEADING = "Get notified when new chapters drop"
  DEFAULT_NEWSLETTER_SUBTEXT =
    "Join the list for updates. No spam - just new guide chapters."

  def initialize(
    site_metadata:,
    message: DEFAULT_MESSAGE,
    newsletter_heading: DEFAULT_NEWSLETTER_HEADING,
    newsletter_subtext: DEFAULT_NEWSLETTER_SUBTEXT
  )
    @message = message
    @newsletter_heading = newsletter_heading
    @newsletter_subtext = newsletter_subtext
    @convertkit_form_id = site_metadata.convertkit_form_id
  end
end
