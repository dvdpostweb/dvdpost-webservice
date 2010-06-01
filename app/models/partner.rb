class Partner < ActiveRecord::Base
  image_column :logo

  named_scope :active, :conditions => {:active => true}
  named_scope :ordered, :order => 'forced_position DESC, rand()', :limit => 6
  named_scope :by_language, lambda {|language| {:conditions => ["language = :language OR language = '' OR language IS NULL", {:language => language.to_s}]}}
end
