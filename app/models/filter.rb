class Filter < ActiveRecord::Base
  serialize :audio
  serialize :subtitles
  serialize :media
  serialize :recommended_ids

  before_save :transform_hashes_to_arrays

  def audience?
    audience_min? || audience_max?
  end

  def rating?
    rating_min? || rating_max?
  end

  def year?
    year_min? || year_max?
  end

  def transform_hashes_to_arrays
    self.audio = audio.keys.collect{|key| key.to_i} if audio? && audio.respond_to?(:keys)
    self.subtitles = subtitles.keys.collect{|key| key.to_i} if subtitles? && subtitles.respond_to?(:keys)
    self.media = media.symbolize_keys.keys if media? && media.respond_to?(:symbolize_keys)
  end
end
