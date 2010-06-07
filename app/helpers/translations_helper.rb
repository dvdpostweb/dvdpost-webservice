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

  def url_for_translation(translation, localized_translation, locale)
    if localized_translation.to_param.blank?
      locale_translations_path(:locale_id => locale.to_param, :original_id => translation.to_param)
    else
      locale_translation_path(:locale_id => locale.to_param, :id => localized_translation.to_param)
    end
  end
end
