class StreamingProduct < ActiveRecord::Base
  has_many :subtitle, :foreign_key => :undertitles_id, :primary_key => :subtitle_id
  has_many :language, :foreign_key => :languages_id, :primary_key => :language_id
  has_many :tokens, :primary_key => :imdb_id, :foreign_key => :imdb_id
  
  named_scope :by_filename, lambda {|filename| {:conditions => {:filename => filename}}}
  named_scope :available, lambda {{:conditions => ['available = ? and available_from < ? and streaming_products.expire_at > ?', 1, Time.now.to_s(:db), Time.now.to_s(:db)]}}
  
end