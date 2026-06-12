require "date"

class Blog::PostCard < Bridgetown::Component
  RECENT_DAYS = 7

  def initialize(post:, card_class: "bg-base-200")
    @post = post
    @card_class = card_class
  end

  def post_date
    date = @post.data.date
    return nil if date.nil?

    if date.respond_to?(:to_date)
      date.to_date
    else
      Date.parse(date.to_s)
    end
  rescue StandardError
    nil
  end

  def formatted_date
    post_date&.strftime("%b %-d, %Y").to_s
  end

  def recent?
    date = post_date

    return false unless date

    days_ago = (Date.today - date).to_i

    days_ago >= 0 && days_ago <= RECENT_DAYS
  end

  def tags
    Array(@post.data.tags).map { |t| t.to_s.strip }.reject(&:empty?)
  end
end
