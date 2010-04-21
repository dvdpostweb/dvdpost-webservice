class QuizzName < ActiveRecord::Base
  establish_connection :dvdpost_main
  
  set_table_name :quizz_name
  
  set_primary_key :quizz_name_id

  alias_attribute :name, :quizz_name
  alias_attribute :type, :quizz_type
  
  def image
    File.join(DVDPost.images_language_path[I18n.locale], banner) if  !banner.empty?
  end

end
