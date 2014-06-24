class Emailer < ActionMailer::Base
   def contact(recipient, subject, message, sent_at = Time.now)
      @subject = subject
      @recipients = recipient
      @from = 'gs@dvdpost.be'
      @sent_on = sent_at
	    @body["title"] = 'alert'
  	  @body["email"] = 'gs@dvdpost.be'
   	  @body["message"] = message
      @headers = {}
   end
end