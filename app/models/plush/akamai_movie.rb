require 'eventmachine'
require 'em-ftp-client'

class AkamaiMovie < ActiveRecord::Base
  establish_connection "plush_#{Rails.env}"

  def self.update_list
    puts 'run'
    EM.run do
      puts 'session'
      EM::FtpClient::Session.new("homessvod.upload.akamai.com", :username => "hesssvodupload",  :password => "HESssvod123") do |ftp|
        puts 'cwd'
        ftp.cwd("308707") do
          puts 'list'
          list = []
          ftp.list do |l1|
            l1.each do |item|
              details = item.to_s.split(' ')
              filename = details[8].split('.')[0]
              list << filename
              if !AkamaiMovie.find_by_filename(filename)
                res = filename.match(/([0-9]*)_A([a-z]*)_S([a-z]*)/)
                puts "insert #{filename}"
                AkamaiMovie.create(:imdb_id => res[1], :filename => filename, :audio => res[2], :subtitle => res[3], :status => 0)
              end
              
            end
            EM.stop
            if list.count > 0
              AkamaiMovie.all(:conditions => ['filename not in (?)', list]).each do |item|
                puts item.id 
                AkamaiMovie.destroy(item.id)
              end
            end
          end
          puts 'end list'
        end
        puts 'end cwd'
      end
      puts 'end session' 
    end
    puts 'end run'
    return nil
  end

end