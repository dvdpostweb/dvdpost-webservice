#require 'ftpfxp'

class StreamingProduct < ActiveRecord::Base
  has_many :tokens, :primary_key => :imdb_id, :foreign_key => :imdb_id
  named_scope :by_filename, lambda {|filename| {:conditions => {:filename => filename}}}
  named_scope :available, lambda {{:conditions => ['available = ? and available_from < ? and streaming_products.expire_at > ? and status = "online_test_ok"', 1, Time.now.to_s(:db), Time.now.to_s(:db)]}}
  def self.fxp
    puts 'conn1'
    @conn1 = Net::FTPFXPTLS.new
    @conn1.passive = true
    @conn1.debug_mode = true
    @conn1.connect('94.139.62.130', 22)
    @conn1.login('PS3user', 'nomoreconnection',1)
    puts 'conn2'
    @conn2 = Net::FTPFXPTLS.new
    @conn2.passive = true
    @conn2.debug_mode = true
    @conn2.connect('homehlsvod.upload.akamai.com', 21)
    @conn2.login('heshlsvodupload', 'HEShlsvod321')

    @conn1.close
    @conn2.close
  end

  def self.zen_output_status
    Zencoder.api_key = '6541e219a225b48e901393d73d906091'
    AkamaiJob.all(:conditions => ["zen_id > 0 and ((status_input ='finished' and (status_output !='finished' or status_output is null)) or status_input != 'finished') and deleted = 0"]).each do |job|
      status_o = Zencoder::Job.progress(job.zen_id).body['outputs'][0]['state']
      status_i = Zencoder::Job.progress(job.zen_id).body['input']['state']

      job.update_attribute(:status_output, status_o)
      job.update_attribute(:status_input, status_i)

    end
    count = AkamaiJob.all(:conditions => ["(status_input = 'failed' or status_output ='failed') and deleted = 0"]).count
    if count > 5
      Emailer.deliver_send('it@dvdpost.be', "zencoder exception #{Date.today}", " there is #{count} movie error")
    end
  end

def self.zen_test
  Zencoder.api_key = '6541e219a225b48e901393d73d906091'
  puts 'test'
  bitrate = 2000
  width =720
  input = "sftp://PS3user:nomoreconnection@94.139.62.130/home/PS3user/dvdpost/SAMPLE_HD_2013@0_Dpc_Afre_Snon_3000k.f4v"
  result = Zencoder::Job.create({:api_key => "6541e219a225b48e901393d73d906091", :region => "europe", :input => input, :outputs => { :audio_bitrate => 64, :audio_sample_rate => 48000, :url => "ftp://hesssvodupload:HESssvod123@homessvod.upload.akamai.com/308707/0_Afre_Snon.ism", :max_frame_rate => 25, :segment_seconds => 2, :type => "segmented", :video_bitrate => bitrate, :width => width, :format => "ism"}}, {:skip_ssl_verify => true})
  puts result.body
  return nil
end
def self.hls_trailer
  content = ''
  sql = 'select distinct t.filename, pl.short_alpha short_lang, ifnull(pu.short_alpha,"non") short_sub, p.season_id , p.episode_id, p.imdb_id from streaming_trailers s
left join tokens_trailers t on s.`filename` = t.filename
join products p on p.imdb_id = s.imdb_id
left join products_undertitles pu on s.subtitle_id = undertitles_id and pu.language_id=1
 join products_languages pl on s.language_id = pl.languages_id and languagenav_id=1
  left join dvdpost_be_prod.akamai_hls_contents h on h.imdb_id = p.imdb_id and h.kind = "Trailer"
where status!= "deleted" and h.imdb_id is null
;'
  results = ActiveRecord::Base.connection.execute(sql)
  results.each_hash do |h| 
    bitrate =  [800, 2200, 3000]
    bitrate.each do |rate|
      if h['season_id'] == '0'
        season_name = ''
      else
        season_name = "S#{sprintf '%02d', h['season_id']}E#{sprintf '%02d', h['episode_id']}_"
      end
      content += "#{h['filename']}@#{h['imdb_id']}_Dpc_A#{h['short_lang']}_S#{h['short_sub']}_#{rate}k.f4v = trailer_#{season_name}#{h['imdb_id']}_A#{h['short_lang']}_S#{h['short_sub']}_#{rate}000.f4v\n"
    end

  end
  directory = "./public/"
  File.open(File.join(directory, 'result_trailer.txt'), 'w') do |f|
    f.puts content
  end
end
def self.hls
  content = ''
  sql = 'select x.*, pl.short_alpha short_lang, ifnull(pu.short_alpha,"non") short_sub,products_year, x.season_id , x.episode_id from 
  (select distinct t.imdb_id, language_id, subtitle_id, filename, quality, products_year, p.season_id, p.episode_id
            from dvdpost_be_prod.tokens t 
            right join dvdpost_be_prod.products p on t.imdb_id = p.imdb_id 
            right join streaming_products sp on sp.imdb_id = p.imdb_id 
            where 
            t.created_at > date_add(now(), interval -14 month) and compensed=0 and studio_id !=750 and (`expire_backcatalogue_at` > now() or expire_backcatalogue_at is null) and available = 1 and status = "online_test_ok" and 
             (((subtitle_id in (1,2) or (language_id in (1,2) and (subtitle_id is null or subtitle_id in (1,2)))) and p.products_type = "DVD_NORM") or
             (p.products_type = "DVD_ADULT"))
            union all
            select distinct t.imdb_id, language_id, subtitle_id, filename, quality, products_year, p.season_id, p.episode_id

            from plush_production.tokens t 
            right join plush_production.products p on t.imdb_id = p.imdb_id
            right join streaming_products sp on sp.imdb_id = p.imdb_id and sp.season_id = p.season_id and p.episode_id = sp.episode_id 

            where ((t.created_at > date_add(now(), interval -14 month) and compensed=0)) 
            and studio_id !=750 and ((`expire_backcatalogue_at` > now() or expire_backcatalogue_at is null) and available = 1 and status = "online_test_ok" and ((subtitle_id in (1,2) or (language_id in (1,2) and (subtitle_id is null or subtitle_id in (1,2)))) and p.products_type = "DVD_NORM" ) or (p.products_type = "DVD_ADULT"))

            ) x
            left join products_undertitles pu on subtitle_id = undertitles_id and pu.language_id=1
            left join dvdpost_be_prod.akamai_hls_contents h on h.imdb_id = x.imdb_id and h.kind = "Movie"
            join products_languages pl on x.language_id = pl.languages_id and languagenav_id=1
            where h.imdb_id is null
            group by x.imdb_id, x.season_id, x.episode_id, x.subtitle_id,x.language_id;'
  results = ActiveRecord::Base.connection.execute(sql)
  results.each_hash do |h| 
    case h['quality']
      when '1080p'
        bitrate =  [800, 2200, 3000]
      when '720p'
        bitrate =  [800, 2200, 3000]
      else
        bitrate =  [800, 2200]
    end
    bitrate.each do |rate|
      test = "#{h['filename']}@0#{h['imdb_id']}_Dpc_A#{h['short_lang']}_S#{h['short_sub']}_3000k.f4v"
      if File.readlines("./public/0.txt").grep(/#{test}/).size > 0
        puts "#{h['imdb_id']}"
        imdb_id = "@0#{h['imdb_id']}"
      else
        imdb_id = "@#{h['imdb_id']}"
      end
      #ps3%40DVDPOST2014
      if h['season_id'] == '0'
        season_name = ''
      else
        season_name = "S#{sprintf '%02d', h['season_id']}E#{sprintf '%02d', h['episode_id']}_"
      end
      content += "#{h['filename']}#{imdb_id}_Dpc_A#{h['short_lang']}_S#{h['short_sub']}_#{rate}k.f4v = #{season_name}#{h['imdb_id']}_A#{h['short_lang']}_S#{h['short_sub']}_#{rate}000.f4v\n"
    end

  end
directory = "./public/"
File.open(File.join(directory, 'result.txt'), 'w') do |f|
  f.puts content
end
end


def self.zen_coder_s
    Zencoder.api_key = '6541e219a225b48e901393d73d906091'
    
    last_job = AkamaiJob.all(:conditions => ['zen_id > 0']).last
    puts 
    zen_id = last_job.zen_id
    body =Zencoder::Job.progress(zen_id).body
    puts body
    status_input = body['input']['state']
    last_job.update_attribute(:status_input, status_input)
    puts last_job.inspect
    puts body
    if  status_input == 'finished' || status_input == 'failed'
      puts 'launch new process'
      sql = 'select x.*, pl.short_alpha short_lang, ifnull(pu.short_alpha,"non") short_sub,products_year, x.season_id , x.episode_id from 
  (select distinct sp.created_at, sp.imdb_id, language_id, subtitle_id, filename, quality, products_year, p.season_id, p.episode_id
            from dvdpost_be_prod.tokens t 
            right join dvdpost_be_prod.products p on t.imdb_id = p.imdb_id
            right join streaming_products sp on sp.imdb_id = p.imdb_id 
            where ((t.created_at > date_add(now(), interval -14 month ) and compensed=0) or sp.created_at > "2014-01-01")  and p.products_type = "DVD_NORM" and  (studio_id !=750 || (studio_id = 750 && sp.videoland = 1)) and (`expire_backcatalogue_at` > now() or expire_backcatalogue_at is null) and available = 1 and status = "online_test_ok" and (subtitle_id in (1,2) or (language_id in (1,2) and (subtitle_id is null or subtitle_id in (1,2))))
            union all
            select distinct sp.created_at, sp.imdb_id, language_id, subtitle_id, filename, quality, products_year, p.season_id, p.episode_id

            from plush_production.tokens t 
            right join plush_production.products p on t.imdb_id = p.imdb_id 
            right join streaming_products sp on sp.imdb_id = p.imdb_id and sp.season_id = p.season_id and p.episode_id = sp.episode_id 

            where ((t.created_at > date_add(now(), interval -14 month) and compensed=0) or sp.created_at > "2014-01-01")  and p.products_type = "DVD_NORM" and studio_id !=750 and (`expire_backcatalogue_at` > now() or expire_backcatalogue_at is null) and available = 1 and status = "online_test_ok" and (subtitle_id in (1,2) or (language_id in (1,2) and (subtitle_id is null or subtitle_id in (1,2))))
            ) x
            left join products_undertitles pu on subtitle_id = undertitles_id and pu.language_id=1
            join products_languages pl on x.language_id = pl.languages_id and languagenav_id=1
            left join akamai_jobs a on a.imdb_id = x.imdb_id and x.season_id = a.season_id and x.episode_id = a.episode_id and a.language_id = x.language_id and ifnull(a.subtitle_id,0) = ifnull(x.subtitle_id,0) and deleted = 0
            where  a.id is null
            group by x.imdb_id, x.season_id, x.episode_id, x.subtitle_id,x.language_id
            order by products_year desc, x.imdb_id desc limit 1;'
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
        if h['season_id'] == '0'
          season_name = ''
        else
          
          season_name = "S#{sprintf '%02d', h['season_id']}E#{sprintf '%02d', h['episode_id']}_"
        end
        puts season_name
        puts h['season_id']
        input = "sftp://PS3user:nomoreconnection@94.139.62.130/home/PS3user/dvdpost/#{h['filename']}#{imdb_id}_Dpc_A#{h['short_lang']}_S#{h['short_sub']}_3000k.f4v"
        result = Zencoder::Job.create({:api_key => "6541e219a225b48e901393d73d906091", :region => "europe", :input => input, :outputs => { :audio_bitrate => 64, :audio_sample_rate => 48000, :url => "ftp://hesssvodupload:HESssvod123@homessvod.upload.akamai.com/308707/#{season_name}#{h['imdb_id']}_A#{h['short_lang']}_S#{h['short_sub']}.ism", :max_frame_rate => 25, :segment_seconds => 2, :type => "segmented", :video_bitrate => bitrate, :width => width, :format => "ism", :drm => { :method => "playready", :provider => "buydrm", :server_key => "89137186-356A-4543-B83F-943699CBD44E", :user_key => "d88e502b-fd8f-4da5-e79b-ea73d132b89f", :media_id => "#{season_name}#{h['imdb_id']}_A#{h['short_lang']}_S#{h['short_sub']}" }}}, {:skip_ssl_verify => true})
        job = AkamaiJob.create(:imdb_id => h['imdb_id'], :language_id => h['language_id'], :subtitle_id => h['subtitle_id'], :zen_id => result.body['id'], :season_id => h['season_id'], :episode_id => h['episode_id'])
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