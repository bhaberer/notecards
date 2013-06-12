class BootstrapFormBuilder < ActionView::Helpers::FormBuilder

  delegate :capture, :content_tag, :tag, to: :@template

  %w[text_field text_area password_field select collection_select time_select time_zone_select email_field].each do |method_name|
    define_method(method_name) do |name, *args|
      errors = object.errors[name].any?? " error" : ""
      error_msg = object.errors[name].any?? content_tag(:span, object.errors[name].join(","), class: "help-inline") : ""

      content_tag :div, class: "control-group#{errors}" do
        field_label(name, *args) + content_tag(:div, class: "controls") do
          super(name, *args) + " " + error_msg
        end
      end
    end
  end

  %w[time_select].each do |method_name|
    define_method(method_name) do |name, *args|
      errors = object.errors[name].any?? " error" : ""
      error_msg = object.errors[name].any?? content_tag(:span, object.errors[name].join(","), class: "help-inline") : ""

      content_tag :div, class: "control-group#{errors}" do
        field_label(name, *args) + content_tag(:div, class: "controls") do
          super(name, *args) + " " + error_msg
        end
      end
    end
  end

  def div(*args, &block)
    options = args.extract_options!
    data = block_given? ? capture(&block) : ''
    content_tag(:div, data, class: options[:class])
  end


  def submit(*args)
    content_tag :div, class: 'control-group' do
      content_tag :div, class: 'controls' do
        super(*args, class: "btn btn-primary")
      end
    end
  end

private

  def field_label(name, *args)
    options = args.extract_options!
    required = object.class.validators_on(name).any? { |v| v.kind_of? ActiveModel::Validations::PresenceValidator}
    label(name, options[:label], class: "control-label" + (if required then " required" else "" end))
  end

  def objectify_options(options)
    super.except(:label)
  end

end
