class StreamingProduct < ActiveRecord::Base
  has_many :tokens, :primary_key => :imdb_id, :foreign_key => :imdb_id
  named_scope :by_filename, lambda {|filename| {:conditions => {:filename => filename}}}
  named_scope :available, lambda {{:conditions => ['available = ? and available_from < ? and streaming_products.expire_at > ? and status = "online_test_ok"', 1, Time.now.to_s(:db), Time.now.to_s(:db)]}}
  
  def self.zen_output_status
    Zencoder.api_key = '6541e219a225b48e901393d73d906091'
    AkamaiJob.all(:conditions => ["zen_id > 0 and (status_input ='finished' and (status_output !='finished' or status_output is null)) or status_input != 'finished' and deleted = 0"]).each do |job|
      status_o = Zencoder::Job.progress(job.zen_id).body['outputs'][0]['state']
      status_i = Zencoder::Job.progress(job.zen_id).body['input']['state']

      job.update_attribute(:status_output, status_o)
      job.update_attribute(:status_input, status_i)

    end
  end


  def self.zen_coder_s
    Zencoder.api_key = '6541e219a225b48e901393d73d906091'
    last_job = AkamaiJob.all(:conditions => ['zen_id > 0']).last
    puts 
    zen_id = last_job.zen_id
    body =Zencoder::Job.progress(zen_id).body
    status_input = body['input']['state']
    last_job.update_attribute(:status_input, status_input)
    puts last_job.inspect
    puts body
    if  status_input == 'finished' || status_input == 'failed'
      puts 'launch new process'
      sql = 'select x.*, pl.short_alpha short_lang, ifnull(pu.short_alpha,"non") short_sub,products_year from 
  (select distinct t.imdb_id, language_id, subtitle_id, filename, quality, products_year
            from dvdpost_be_prod.tokens t 
            join dvdpost_be_prod.products p on t.imdb_id = p.imdb_id and p.products_type = "DVD_NORM"
            join streaming_products sp on sp.imdb_id = p.imdb_id and studio_id !=750 and (`expire_backcatalogue_at` > now() or expire_backcatalogue_at is null) and available = 1 and status = "online_test_ok" and (subtitle_id in (1,2) or (language_id in (1,2) and (subtitle_id is null or subtitle_id in (1,2))))
            where t.created_at > date_add(now(), interval -14 month) and compensed=0
            union all
            select distinct t.imdb_id, language_id, subtitle_id, filename, quality, products_year

            from plush_production.tokens t 
            join plush_production.products p on t.imdb_id = p.imdb_id and p.products_type = "DVD_NORM"
            join streaming_products sp on sp.imdb_id = p.imdb_id and studio_id !=750 and (`expire_backcatalogue_at` > now() or expire_backcatalogue_at is null) and available = 1 and status = "online_test_ok" and (subtitle_id in (1,2) or (language_id in (1,2) and (subtitle_id is null or subtitle_id in (1,2))))

            where t.created_at > date_add(now(), interval -14 month) and compensed=0
            ) x
            left join products_undertitles pu on subtitle_id = undertitles_id and pu.language_id=1
            join products_languages pl on x.language_id = pl.languages_id and languagenav_id=1
            left join akamai_jobs a on a.imdb_id = x.imdb_id and a.language_id = x.language_id and ifnull(a.subtitle_id,0) = ifnull(x.subtitle_id,0) and deleted = 0
            where  a.id is null
            group by x.imdb_id, x.subtitle_id,x.language_id
            order by products_year desc, x.imdb_id desc limit 1'
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
        test = "#{h['filename']}@0#{h['imdb_id']}_Dpc_A#{h['short_lang']}_S#{h['short_sub']}_3000k.f4v"
        if File.readlines("./public/0.txt").grep(/#{test}/).size > 0
          imdb_id = "@0#{h['imdb_id']}"
        else
          imdb_id = "@#{h['imdb_id']}"
        end
        #ps3%40DVDPOST2014
        input = "sftp://PS3user:nomoreconnection@94.139.62.130/home/PS3user/dvdpost/#{h['filename']}#{imdb_id}_Dpc_A#{h['short_lang']}_S#{h['short_sub']}_3000k.f4v"
        #result = Zencoder::Job.create({:api_key => "6541e219a225b48e901393d73d906091", :region => "europe", :input => input, :outputs => { :audio_bitrate => 64, :audio_sample_rate => 48000, :url => "ftp://hesssvodupload:HESssvod123@homessvod.upload.akamai.com/308707/#{h['imdb_id']}_A#{h['short_lang']}_S#{h['short_sub']}.ism", :max_frame_rate => 25, :segment_seconds => 2, :type => "segmented", :video_bitrate => bitrate, :width => width, :format => "ism", :drm => { :method => "playready", :provider => "buydrm", :server_key => "89137186-356A-4543-B83F-943699CBD44E", :user_key => "d88e502b-fd8f-4da5-e79b-ea73d132b89f", :media_id => "#{h['imdb_id']}_A#{h['short_lang']}_S#{h['short_sub']}" }}}, {:ca_file => "/usr/share/curl/ca-bundle.crt"})
        result = Zencoder::Job.create({:api_key => "6541e219a225b48e901393d73d906091", :region => "europe", :input => input, :outputs => { :audio_bitrate => 64, :audio_sample_rate => 48000, :url => "ftp://hesssvodupload:HESssvod123@homessvod.upload.akamai.com/308707/#{h['imdb_id']}_A#{h['short_lang']}_S#{h['short_sub']}.ism", :max_frame_rate => 25, :segment_seconds => 2, :type => "segmented", :video_bitrate => bitrate, :width => width, :format => "ism", :drm => { :method => "playready", :provider => "buydrm", :server_key => "89137186-356A-4543-B83F-943699CBD44E", :user_key => "d88e502b-fd8f-4da5-e79b-ea73d132b89f", :media_id => "#{h['imdb_id']}_A#{h['short_lang']}_S#{h['short_sub']}" }}}, {:skip_ssl_verify => true})
        job = AkamaiJob.create(:imdb_id => h['imdb_id'], :language_id => h['language_id'], :subtitle_id => h['subtitle_id'],:zen_id => result.body['id'])
        puts result.body
      end
    end
    return nil
    #result = Zencoder::Job.create({:input => "http://vjs.zencdn.net/v/oceans.mp4",:outputs => {:test => true,:url => "ftp://hesssvodupload:HESssvod123@homessvod.upload.akamai.com/308707/test.ism" },:api_key => "6541e219a225b48e901393d73d906091" })
    #puts result.inspect
  end
  def self.open
    require "openssl"
puts OpenSSL::OPENSSL_VERSION
puts "SSL_CERT_FILE: %s" % OpenSSL::X509::DEFAULT_CERT_FILE
puts "SSL_CERT_DIR: %s" % OpenSSL::X509::DEFAULT_CERT_DIR
end
end