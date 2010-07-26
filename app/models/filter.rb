class Filter < ActiveRecord::Base
  belongs_to :customer

  serialize :audio
  serialize :subtitles
  serialize :media
  serialize :recommended_ids

  before_save :transform_hashes_to_arrays

  def audience?
    (audience_min? || audience_max?) && !(audience_min == 0 && audience_max == 18)
  end

  def rating?
    (rating_min? || rating_max?) && !(rating_min == 0 && rating_max == 5)
  end

  def year?
    (year_min? || year_max?) && !(year_min == 0 && year_max >= Time.now.year)
  end

  def transform_hashes_to_arrays
    self.audio = audio.keys.collect{|key| key.to_i} if audio? && audio.respond_to?(:keys)
    self.subtitles = subtitles.keys.collect{|key| key.to_i} if subtitles? && subtitles.respond_to?(:keys)
    self.media = media.symbolize_keys.keys if media? && media.respond_to?(:symbolize_keys)
  end

  def country_name
    ProductCountry.find(country_id).name if country_id?
  end

  def audio_names
    Language.by_language(I18n.locale).find(audio).collect(&:name).join(', ') if audio?
  end

  def subtitle_names
    Subtitle.by_language(I18n.locale).find(subtitles).collect(&:name).join(', ') if subtitles?
  end

  def used?
    audience? || rating? || year? || media? || country_id? || dvdpost_choice? || audio? || subtitles?
  end

  def update_with_defaults(options)
    self.media            = nil || options[:media]
    self.country_id       = nil || options[:country_id]
    self.audience_min     = nil || options[:audience_min]
    self.audience_max     = nil || options[:audience_max]
    self.rating_min       = nil || options[:rating_min]
    self.rating_max       = nil || options[:rating_max]
    self.year_min         = nil || options[:year_min]
    self.year_max         = nil || options[:year_max]
    self.audio            = nil || options[:audio]
    self.subtitles        = nil || options[:subtitles]
    self.recommended_ids  = nil || options[:recommended_ids]
    self.dvdpost_choice   = nil || options[:dvdpost_choice]
    save
  end
end
