class QuizzName < ActiveRecord::Base
  set_table_name :quizz_name

  set_primary_key :quizz_name_id

  alias_attribute :name, :quizz_name
  alias_attribute :type, :quizz_type

  def self.on_focus
    find_by_focus(1)
  end

  def image
    File.join(DVDPost.images_language_path[I18n.locale], banner) if  !banner.empty?
  end
end
