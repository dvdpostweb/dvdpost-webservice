class Session < ActiveRecord::Base
  def self.delete_old_sessions
    puts "remove delete"
    #Emailer.deliver_send('gs@dvdpost.be', "session remove #{Date.today}", "session remove")
    Session.destroy_all("created_at < '#{29.days.ago}'")
    return "session deleted #{Date.today}"
  end
end
