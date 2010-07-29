class SponsorshipsEmailsController < ApplicationController
  def create
    @sponsorships_email = SponsorshipEmail.new(params[:sponsorship_email].merge(:customer => current_customer))
    if @sponsorships_email.save
      mail = Email.by_language(I18n.locale).find(DVDPost.email[:sponsorships_invitation])
      recipient = params[:sponsorship_email][:email]
      options = {"\\$\\$\\$godfather_name\\$\\$\\$" => "#{current_customer.first_name.capitalize} #{current_customer.last_name.capitalize}", 
      "\\$\\$\\$son_name\\$\\$\\$" => "#{params[:sponsorship_email][:firstname].capitalize} #{params[:sponsorship_email][:lastname].capitalize}",
      "\\$\\$\\$target_email\\$\\$\\$" => recipient}
      email_data_replace(mail.subject, options)
      subject = email_data_replace(mail.subject, options)
      message = email_data_replace(mail.body, options)
      Emailer.deliver_send(recipient, subject, message)
      respond_to do |format|
        format.html {render :action => :new }
        format.js {render :partial => 'sponsorships/show/email_form'}
      end
    else
      respond_to do |format|
        format.html {render :action => :new }
        format.js {render :partial => 'sponsorships/show/email_form'}
      end
    end
  end
end
