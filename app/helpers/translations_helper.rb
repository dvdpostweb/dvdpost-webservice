module TranslationsHelper
  def css_class_for_translation(translation, localized_translation)
    if localized_translation.text.blank?
      'miss'
    elsif (localized_translation.text == translation.text) && !@locale.main?
      'susp'
    elsif (!localized_translation.updated_at && translation.updated_at) || (translation.updated_at && (localized_translation.updated_at < translation.updated_at))
      'old'
    end
  end
end
