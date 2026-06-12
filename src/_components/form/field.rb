class Form::Field < Bridgetown::Component
  def initialize(label:, name:, type: "text", id: nil, required: false, placeholder: nil, rows: 5, classes: "")
    @label = label.to_s
    @name = name.to_s
    @type = type.to_s
    @id = (id || name).to_s
    @required = required
    @placeholder = placeholder.to_s
    @rows = rows.to_i
    @html_classes = classes.to_s.strip
  end

  def textarea?
    @type == "textarea"
  end

  def field_classes
    base = textarea? ? "textarea" : "input"
    [base, @html_classes, "w-full"].reject(&:empty?).join(" ")
  end

  def field_attributes
    attributes = {
      id: @id,
      name: @name,
      class: field_classes
    }
    attributes[:rows] = @rows if textarea?
    attributes[:type] = @type unless textarea?
    attributes[:required] = true if @required
    if !textarea? && !@placeholder.empty?
      attributes[:placeholder] = @placeholder
    end
    attributes
  end

  def field_markup
    attributes = helpers.html_attributes(field_attributes)

    if textarea?
      helpers.safe("<textarea #{attributes}></textarea>")
    else
      helpers.safe("<input #{attributes}>")
    end
  end
end
