class Emailer < ActionMailer::Base
   def send(recipient, subject, message, sent_at = Time.now)
      @subject = subject
      @recipients = recipient
      @from = 'dvdpost@dvdpost.be'
      @sent_on = sent_at
   	  @body["message"] = message
      @headers = {}
   end
end
