class ContestName < ActiveRecord::Base
  set_table_name :contest_name
  set_primary_key :contest_name_id

  named_scope :by_language, lambda {|language| {:conditions => {(language == 'nl' ? :active_nl : (language == 'en' ? :active_en : :active_fr)) => 1}}}
  named_scope :by_date, :conditions => "validity > NOW()"
  named_scope :ordered, :order => "validity ASC"

  def image
    File.join(DVDPost.images_language_path[I18n.locale], banner) unless banner.blank?
  end

  def image_big
    File.join(DVDPost.images_language_path[I18n.locale], jaquette) unless jaquette.blank?
  end
end
