ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {  
  :address              => "email-smtp.eu-west-1.amazonaws.com", 
  :port                 => 587,
  :domain               => "dvdpost.be",
  :authentication       => "plain",
  :user_name            => "AKIAICQS7KIVA5N62SKQ",
  :password             => "Au/ZyAC8yBAZGGSPdGDNEz00v2biQZPjUnxpd+qLl3Xn",
  :enable_starttls_auto => true
}


#ActionMailer::Base.smtp_settings = {
#   :address => "mail.dvdpost.local",
#   :port => "25",
#   :authentication => :none,
#   :domain => "dvdpost.be"
#}

ActionMailer::Base.default_content_type = "text/html"
ActionMailer::Base.perform_deliveries = true
