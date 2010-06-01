class Partner < ActiveRecord::Base
  upload_column :logo

  named_scope :by_language, lambda {|language| {:conditions => ['language = :language OR language IS NULL', {:language => language.to_s}]}}
end
