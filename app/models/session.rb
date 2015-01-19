class Session < ActiveRecord::Base
  def self.delete_old_sessions
    puts "remove delete"
    Session.destroy_all("created_at < '#{29.days.ago}'")
    return "session deleted #{Date.today}"
  end
end
