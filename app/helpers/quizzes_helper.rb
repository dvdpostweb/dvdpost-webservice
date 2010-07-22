module QuizzesHelper
  def flash_url(quizz, customer)
    language_id = DVDPost.customer_languages[I18n.locale]
    url = "http://www.dvdpost.be/quizz/quizz_viewer#{quizz.quizz_type}#{language_id}.swf"
    params = "quizz_id=#{quizz.quizz_name_id}&lang=#{language_id}&customerzz=#{customer.to_param}&email=#{customer.email}&pseudo=#{customer.first_name}"
    "#{url}?#{params}"
  end

  def carousel_image_url(quizz)
    "#{DVDPost.images_language_path[I18n.locale]}/old_quizz/q#{quizz.quizz_name_id}.gif"
  end
end