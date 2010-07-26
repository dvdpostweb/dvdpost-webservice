class Emailer < ActionMailer::Base
   def send(recipient, subject, message, sent_at = Time.now)
      @subject = subject
      @recipients = recipient
      @from = 'tiguss@gmail.com'
      @sent_on = sent_at
	    @body["title"] = 'This is title'
  	  @body["email"] = 'tigus.s@gmail.com'
   	  @body["message"] = message
      @headers = {}
   end
end
