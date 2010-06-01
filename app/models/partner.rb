class Partner < ActiveRecord::Base
  upload_column :logo

  named_scope :active, :conditions => {:active => true}
  named_scope :ordered, :order => 'forced_position DESC, rand()'
  named_scope :by_language, lambda {|language| {:conditions => ["language = :language OR language = '' OR language IS NULL", {:language => language.to_s}]}}
end
