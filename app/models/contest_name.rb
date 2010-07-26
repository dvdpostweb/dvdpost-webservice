class ContestName < ActiveRecord::Base
  set_table_name :contest_name

  set_primary_key :contest_name_id

  named_scope :by_language, lambda {|language| {:conditions => {(language == 'nl' ? :active_nl : (language == 'en' ? :active_en : :active_fr)) => 1}}}
  named_scope :by_date, :conditions => "validity > now()"
  named_scope :ordered, :order => "validity asc"
  def image
    File.join(DVDPost.images_language_path[I18n.locale], banner) if !banner.empty?
  end

  def image_big
    File.join(DVDPost.images_language_path[I18n.locale], jaquette) if !jaquette.empty?
  end

end
