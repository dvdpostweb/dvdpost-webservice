class SponsorshipsEmailsController < ApplicationController
  def create
    mail = Email.by_language(I18n.locale).find(DVDPost.email[:sponsorships_invitation])
    recipient = params[:sponsorship_email][:email]
    options = {"\\$\\$\\$godfather_name\\$\\$\\$" => "#{current_customer.first_name.capitalize} #{current_customer.last_name.capitalize}", 
    "\\$\\$\\$son_name\\$\\$\\$" => "#{params[:sponsorship_email][:firstname].capitalize} #{params[:sponsorship_email][:lastname].capitalize}",
    "\\$\\$\\$target_email\\$\\$\\$" => recipient}
    email_data_replace(mail.subject, options)
    subject = email_data_replace(mail.subject, options)
    message = email_data_replace(mail.body, options)
    Emailer.deliver_send(recipient, subject, message)
    redirect_to sponsorships_path
  end
end
