ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
   :address => "192.168.100.11",
   :port => "25",
   :authentication => :none,
   :domain => "dvdpost.be"
}
ActionMailer::Base.default_content_type = "text/html"
ActionMailer::Base.perform_deliveries = true