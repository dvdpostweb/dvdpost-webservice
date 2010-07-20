module QuizzesHelper
  def flash_url(quizz_id, customer)
    "http://www.dvdpost.be/quizz/quizz_viewer11.swf?quizz_id=#{quizz_id}&lang=1&customerzz=#{customer.to_param}&email=#{customer.email}&pseudo=#{customer.first_name}"
  end
end