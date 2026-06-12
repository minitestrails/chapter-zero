class Shared::NewsletterForm < Bridgetown::Component
  def initialize(convertkit_form_id:, convertkit_account: nil)
    @convertkit_form_id = convertkit_form_id.to_s.strip
    @convertkit_account = convertkit_account.to_s.strip
  end

  def render?
    @convertkit_form_id != "" && @convertkit_account != ""
  end
end
