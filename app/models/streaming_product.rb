class StreamingProduct < ActiveRecord::Base
  has_many :tokens, :primary_key => :imdb_id, :foreign_key => :imdb_id
  named_scope :by_filename, lambda {|filename| {:conditions => {:filename => filename}}}
  named_scope :available, lambda {{:conditions => ['available = ? and available_from < ? and streaming_products.expire_at > ? and status = "online_test_ok"', 1, Time.now.to_s(:db), Time.now.to_s(:db)]}}
  def self.zen_coder
    
    myFile = File.open("log/myFile.txt", "w")
    sql = 'select x.*, pl.short_alpha short_lang, ifnull(pu.short_alpha,"non") short_sub
from
(select distinct t.imdb_id, language_id, subtitle_id, filename, quality
from plush_staging.tokens t 
join plush_staging.products p on t.imdb_id = p.imdb_id and p.products_type = "DVD_NORM"
join streaming_products sp on sp.imdb_id = p.imdb_id and studio_id !=750 and (`expire_backcatalogue_at` > now() or expire_backcatalogue_at is null) and available = 1 and (subtitle_id in (1,2) or language_id in (1,2))
where t.created_at > date_add(now(), interval -14 month) and compensed=0
union all
select distinct t.imdb_id, language_id, subtitle_id, filename, quality

from plush_staging.tokens t 
join plush_staging.products p on t.imdb_id = p.imdb_id and p.products_type = "DVD_NORM"
join streaming_products sp on sp.imdb_id = p.imdb_id and studio_id !=750 and (`expire_backcatalogue_at` > now() or expire_backcatalogue_at is null) and available = 1 and (subtitle_id in (1,2) or language_id in (1,2))

where t.created_at > date_add(now(), interval -14 month) and compensed=0
) x
left join products_undertitles pu on subtitle_id = undertitles_id and pu.language_id=1
join products_languages pl on x.language_id = pl.languages_id and languagenav_id=1
group by x.imdb_id, subtitle_id,language_id
order by x.imdb_id limit 10'
    results = ActiveRecord::Base.connection.execute(sql)
    results.each_hash do |h| 
      	case h['quality']
      	when '1080p'
      		bitrate = 3000
      		width =1920
      	when '720p'
      		bitrate = 2500
      		width =1024
      	else
      		bitrate = 2000
      		width =720
      	end
      var = <<-EOF
    {
      "api_key": "6541e219a225b48e901393d73d906091",
      "input": "sftp://PS3user:ps3%40DVDPOST2014@94.139.62.130:22/home/PS3user/dvdpost/#{h['filename']}@#{h['imdb_id']}_Dpc_A#{h['short_lang']}_S#{h['short_sub']}_3000k.f4v",
      "region": "europe",
      "outputs":
      {
        "audio_bitrate": 64,
        "audio_sample_rate": 48000,
        "url": "ftp://hesssvodupload:HESssvod123@homessvod.upload.akamai.com/308707/#{h['imdb_id']}_A#{h['short_lang']}_S#{h['sub']}.ism",
        "max_frame_rate": 25,
        "segment_seconds": 2,
        "type": "segmented",
        "video_bitrate": #{bitrate},
        "width": #{width},
        "format": "ism",
        "drm":    
        {
          "method": "playready",
          "provider": "buydrm",
          "server_key": "89137186-356A-4543-B83F-943699CBD44E",
          "user_key": "d88e502b-fd8f-4da5-e79b-ea73d132b89f",
          "media_id": "h['imdb_id']_Ah['short_lang']_Sh['short_sub']"
        }
      }
    }
    EOF
    myFile.write(var)
    end  
    
    myFile.close
  end
end