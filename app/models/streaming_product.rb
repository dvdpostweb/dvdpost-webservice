class StreamingProduct < ActiveRecord::Base
  has_many :tokens, :primary_key => :imdb_id, :foreign_key => :imdb_id
  named_scope :by_filename, lambda {|filename| {:conditions => {:filename => filename}}}
  named_scope :available, lambda {{:conditions => ['available = ? and available_from < ? and streaming_products.expire_at > ? and status = "online_test_ok"', 1, Time.now.to_s(:db), Time.now.to_s(:db)]}}
  def self.zen_coder
    
    myFile = File.open("log/myFile.txt", "w")
    5.times do |i|
      var = <<-EOF
    {#{i}
      "api_key": "6541e219a225b48e901393d73d906091",
      "input": "sftp://PS3user:ps3%40DVDPOST2014@94.139.62.130:22/home/PS3user/dvdpost/12Y_SLAVE_2013@2024544_Dpc_Aeng_Sfre_3000k.f4v",
      "region": "europe",
      "outputs":
      {
        "audio_bitrate": 64,
        "audio_sample_rate": 48000,
        "url": "ftp://hesssvodupload:HESssvod123@homessvod.upload.akamai.com/308707/2024544_Aeng_Sfre.ism",
        "max_frame_rate": 25,
        "segment_seconds": 2,
        "type": "segmented",
        "video_bitrate": 3000,
        "width": 1920,
        "format": "ism",
        "drm":    
        {
          "method": "playready",
          "provider": "buydrm",
          "server_key": "89137186-356A-4543-B83F-943699CBD44E",
          "user_key": "d88e502b-fd8f-4da5-e79b-ea73d132b89f",
          "media_id": "2024544_Aeng_Sfre"
        }
      }
    }
    EOF
    myFile.write(var)
    end  
    
    myFile.close
  end
end