module CDN
  class << self
    def connect_url(token)
      "rtmp://secureflash.cdnlayer.com/secure_dvstream/_definst_/?token=#{token}"
    end

    def source_file_regexp
      /(rtmp|rtmpt|rtmps):\/\/secureflash.cdnlayer.com\/secure_dvstream\/(_definst_\/|)(.*)\?token=.*/
    end
  end
end