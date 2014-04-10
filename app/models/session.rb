class Session < ActiveRecord::Base
  def self.delete_old_sessions
    Session.destroy_all("created_at < '#{29.days.ago}'")
  end
end
