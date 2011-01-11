class StreamingProduct < ActiveRecord::Base
  has_many :subtitle, :foreign_key => :undertitles_id, :primary_key => :subtitle_id
  has_many :language, :foreign_key => :languages_id, :primary_key => :language_id
  has_many :tokens, :primary_key => :imdb_id, :foreign_key => :imdb_id
  has_many :products, :primary_key => :imdb_id, :foreign_key => :imdb_id, :limit => 1
  
  named_scope :by_filename, lambda {|filename| {:conditions => {:filename => filename}}}
  named_scope :available, lambda {{:conditions => ['available = ? and available_from < ? and streaming_products.expire_at > ? and status = "online_test_ok"', 1, Time.now.to_s(:db), Time.now.to_s(:db)]}}
  named_scope :prefered_audio, lambda {|language_id| {:conditions => {:language_id => language_id }}}
  named_scope :prefered_subtitle, lambda {|subtitle_id| {:conditions => ['subtitle_id = ? and language_id <> ?', subtitle_id, subtitle_id ]}}
  named_scope :not_prefered, lambda {|language_id| {:conditions => ["language_id != :language_id and (subtitle_id != :language_id or subtitle_id is null)",{:language_id => language_id}]}}
  
  def self.get_streaming_by_imdb_id(imdb_id, local)
    if Rails.env == "production"
      streaming = available.prefered_audio(DVDPost.customer_languages[local]).find_all_by_imdb_id(imdb_id)
      streaming += available.prefered_subtitle(DVDPost.customer_languages[local]).find_all_by_imdb_id(imdb_id)
      streaming += available.not_prefered(DVDPost.customer_languages[local]).find_all_by_imdb_id(imdb_id)
    else
      streaming = prefered_audio(DVDPost.customer_languages[local]).find_all_by_imdb_id(imdb_id)
      streaming += prefered_subtitle(DVDPost.customer_languages[local]).find_all_by_imdb_id(imdb_id)
      streaming += not_prefered(DVDPost.customer_languages[local]).find_all_by_imdb_id(imdb_id)
    end
    streaming
  end
end