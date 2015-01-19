require 'eventmachine'
require 'em-ftp-client'
require 'timeout'




class AkamaiMovie < ActiveRecord::Base
  establish_connection "plush_#{Rails.env}"

  def self.update_list
    puts "run #{Date.today}"
    begin
      status = Timeout::timeout(600) {
        EM.run do
          EM::FtpClient::Session.new("homessvod.upload.akamai.com", :username => "hesssvodupload",  :password => "HESssvod123") do |ftp|
            ftp.cwd("308707") do
              list = []
              ftp.list do |l1|
                l1.each do |item|
                  details = item.to_s.split(' ')
                  filename = details[8].split('.')[0]
                  list << filename
                  if !AkamaiMovie.find_by_filename(filename)
                    res = filename.match(/(S([0-9]*)E([0-9]*)_)?([0-9]*)_A([a-z]*)_S([a-z]*)/)
                    puts "insert #{filename}"
                    season_id = res[2] || 0
                    episode_id = res[3] || 0
                    #AkamaiMovie.create(:imdb_id => res[4], :filename => filename, :audio => res[5], :subtitle => res[6], :status => 0)
                    AkamaiMovie.create(:imdb_id => res[4], :filename => filename, :audio => res[5], :subtitle => res[6], :status => 0, :season_id => season_id, :episode_id => episode_id)
                  end
                  
                end
                EM.stop
                if list.count > 0
                  AkamaiMovie.all(:conditions => ['filename not in (?)', list]).each do |item|
                    puts "remove #{item.id}" 
                    AkamaiMovie.destroy(item.id)
                  end
                end
              end
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

  
  def self.error
    puts "error"
  end

end
