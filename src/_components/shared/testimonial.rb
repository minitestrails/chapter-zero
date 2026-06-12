class Shared::Testimonial < Bridgetown::Component
  def initialize(testimonial:)
    @testimonial = testimonial
  end

  def prepared_testimonial
    @prepared_testimonial ||= helpers.testimonial_data(@testimonial)
  end
end
