class FormBuilder < ActionView::Helpers::FormBuilder
  #include TagHelper

  INLINE_WRAPPER_CLASS = "flex items-center space-x-3"
  TEXT_FIELD_CLASS = "relative flex-1 w-full px-4 py-2 text-base text-gray-700 placeholder-gray-400 bg-white border border-transparent border-gray-300 rounded-lg appearance-none shadow-sm focus:outline-none focus:ring-2 focus:ring-purple-600 focus:border-transparent"
  CHECK_BOX_CLASS = "w-6 h-6 mr-3 text-purple-600 border border-gray-300 appearance-none transition duration-150 ease-out form-tick rounded-md checked:bg-purple-600 focus:ring-purple-500 checked:border-transparent focus:outline-none cursor-pointer"
  RADIO_BUTTON_CLASS = "w-6 h-6 mr-3 text-purple-600 border-gray-300 transition duration-150 ease-out focus:ring-purple-500 cursor-pointer"
  SWITCH_TOGGLE_CLASS =  "w-6 h-6 text-purple-600 bg-white border border-gray-300 rounded-full appearance-none transition duration-150 ease-out transform checked:translate-x-full checked:bg-purple-600 focus:ring-purple-500 cursor-pointer"
  SWITCH_TOGGLE_WRAPPER_CLASS = "flex w-12 h-6 bg-gray-200 rounded-full"
  LABEL_CLASS = "text-sm font-medium text-gray-700"
  SUBMIT_BUTTON_CLASS = "px-4 py-2 text-base font-semibold text-center text-white bg-purple-600 rounded-md hover:bg-purple-700 focus:ring-purple-500 focus:ring-offset-purple-200 transition ease-in duration-150 focus:outline-none focus:ring-2 focus:ring-offset-2 cursor-pointer"
  REQUIRED_LABEL_CLASS = "required-dot"

  def merge_class(klass, options)
    options = options || {}
    override = options.try(:[], :class) || ""
    options[:class] = klass.split(" ").concat(override.split(" ")).uniq.join(" ")
    options
  end

  # Add asterisk and styling to label
  def label(method, content_or_options = nil, options = nil, &block)
    if content_or_options && content_or_options.class == Hash
      options = content_or_options
    else
      content = content_or_options
    end

    options = merge_class(LABEL_CLASS, options)

    if object.class.validators_on(method).map(&:class).include? ActiveRecord::Validations::PresenceValidator
      options = merge_class(REQUIRED_LABEL_CLASS, options)
    end

    super(method, content, options, &block)
  end

  def text_field(method, options = {})
    super(method, merge_class(TEXT_FIELD_CLASS, options))
  end

  def email_field(method, options = {})
    super(method, merge_class(TEXT_FIELD_CLASS, options))
  end

  def number_field(method, options = {})
    super(method, merge_class(TEXT_FIELD_CLASS, options))
  end

  def password_field(method, options = {})
    super(method, merge_class(TEXT_FIELD_CLASS, options))
  end

  def telephone_field(method, options = {})
    super(method, merge_class(TEXT_FIELD_CLASS, options))
  end

  def phone_field(method, options = {})
    super(method, merge_class(TEXT_FIELD_CLASS, options))
  end

  def week_field(method, options = {})
    super(method, merge_class(TEXT_FIELD_CLASS, options))
  end

  def month_field(method, options = {})
    super(method, merge_class(TEXT_FIELD_CLASS, options))
  end

  def time_field(method, options = {})
    super(method, merge_class(TEXT_FIELD_CLASS, options))
  end

  def text_area(method, options = {})
    super(method, merge_class(TEXT_FIELD_CLASS, options))
  end

  def search_field(method, options = {})
    super(method, merge_class(TEXT_FIELD_CLASS, options))
  end

  def radio_button(method, tag_value = nil, options = {})
    super(method, tag_value = nil, merge_class(RADIO_BUTTON_CLASS, options))
  end

  def collection_radio_buttons(method, collection, value_method, text_method, options = {}, html_options = {})
    super(method, collection, value_method, text_method, options, html_options) do |b|
      @template.content_tag(:div,
                            b.radio_button(class: RADIO_BUTTON_CLASS) +
                            b.label(class: LABEL_CLASS),
                            { class: INLINE_WRAPPER_CLASS }
                         )
    end
  end

  def collection_check_boxes(method, collection, value_method, text_method, options = {}, html_options = {})
    super(method, collection, value_method, text_method, options, html_options) do |b|
      @template.content_tag(:div,
                            b.radio_button(class: CHECK_BOX_CLASS) +
                            b.label(class: LABEL_CLASS),
                            { class: INLINE_WRAPPER_CLASS }
                         )
    end
  end

  def check_box(method, options = {}, checked_value = "1", unchecked_value = "0")
    super(method, merge_class(CHECK_BOX_CLASS, options), checked_value, unchecked_value)
  end

  def switch_toggle(method, options = {}, checked_value = "1", unchecked_value = "0")
    @template.content_tag(:div,
                          @template.check_box(@object_name, method, merge_class(SWITCH_TOGGLE_CLASS, options), checked_value, unchecked_value),
                          { class: SWITCH_TOGGLE_WRAPPER_CLASS }
                         )
  end

  def submit(value = nil, options = {})
    super(value, merge_class(SUBMIT_BUTTON_CLASS, options))
  end
end

