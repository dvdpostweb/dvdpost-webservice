class StreamingProduct < ActiveRecord::Base
  has_many :subtitle, :foreign_key => :undertitles_id, :primary_key => :subtitle_id
  has_many :language, :foreign_key => :languages_id
end