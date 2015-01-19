require 'net/sftp'

class AkamaiHlsContent < ActiveRecord::Base

  def self.update_list_hls
    puts "run hls #{Date.today}"
    begin
      status = Timeout::timeout(600) {
        
          Net::SFTP.start('homehlsvod.upload.akamai.com', 'sshacs', :password => 'password') do |sftp|
            list = []
            sftp.dir.foreach("/308709") do |entry|
              details = entry.longname.to_s.split(' ')
              if entry.name.length > 20
                filename = entry.name.split('.')[0]
                short_filename = filename.match(/(.*)_[0-9]*/)
                list << short_filename[1]
                if !AkamaiHlsContent.find_by_filename(short_filename[1])
                  if filename.include?('trailer')
                    res = filename.match(/trailer_(S([0-9]*)E([0-9]*)_)?([0-9]*)_A([a-z]*)_S([a-z]*)_.*/)
                    kind = 'Trailer'
                   else
                    res = filename.match(/(S([0-9]*)E([0-9]*)_)?([0-9]*)_A([a-z]*)_S([a-z]*)_.*/)
                    kind = 'Movie'
                  end
                  puts "insert #{filename}"
                  season_id = res[2] || 0
                  episode_id = res[3] || 0
                  puts "#{res[5]} #{res[6]}"
                  language = Language.find(:first, :conditions => ["short_alpha = '#{res[5]}'"])
                  subtitle = Subtitle.find(:first, :conditions => ["short_alpha = '#{res[6]}'"])
                  if language && (subtitle || res[6] == 'non')
                    language_id = language.id
                    subtitle_id = res[6] == 'non' ? nil : subtitle.id
                    
                    AkamaiHlsContent.create(:imdb_id => res[4], :filename => short_filename[1], :language_id => language_id, :subtitle_id => subtitle_id, :season_id => season_id, :episode_id => episode_id, :kind => kind)
                  else
                    puts 'error of content : language or subtitle'
                  end
                end
              end
            end
            if list.count > 0
                  AkamaiHlsContent.all(:conditions => ['filename not in (?)', list]).each do |item|
                    puts "remove #{item.id}" 
                    AkamaiHlsContent.destroy(item.id)
              end
            end
          end
      }
    rescue Timeout::Error
      puts "Timeout"
      Emailer.deliver_send('it@dvdpost.be', "timeout update_list #{Date.today}", "impossible to load list of movie on akamai ftp")
      return nil
    rescue Exception => ex
      puts "EXCEPTION - #{ex.message}"
      Emailer.deliver_send('it@dvdpost.be', "exceptionupdate_list #{Date.today}", "EXCEPTION - #{ex.message}")
      return nil
    end
    
    return nil
  end
  def self.test_name
    entry = '996972_Azzz_Snon_800000.f4v'
    
    filename = entry.split('.')[0]
    res = filename.match(/(S([0-9]*)E([0-9]*)_)?([0-9]*)_A([a-z]*)_S([a-z]*)_.*/)
    puts res.inspect
    puts "filename "+filename
Language.find(:first, :conditions => ["short_alpha = '#{res[5]}'"])
    puts "lang id "
    
    res = filename.match(/(.*)_[0-9]*/)
    puts res.inspect
    puts res[1]
    
  end
end