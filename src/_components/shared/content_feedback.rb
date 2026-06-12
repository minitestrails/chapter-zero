class Shared::ContentFeedback < Bridgetown::Component
  def initialize(label:, title: nil, order: nil)
    @label = label.to_s
    @title = title.to_s.strip
    @order = order
  end

  def feedback_subject
    case @label
    when "chapter"
      "Chapter #{@order} feedback"
    when "post"
      "Blog feedback - #{@title}"
    else
      @title.empty? ? "Feedback" : "Feedback - #{@title}"
    end
  end
end
