class SponsorshipsController < ApplicationController
  def show
    @free = current_customer.sponsorships.free.ordered.group_by_son
    @stop = current_customer.sponsorships.stop.ordered.group_by_son
    @ok = current_customer.sponsorships.ok.ordered.group_by_son

    @gifts_history = current_customer.gifts_history.ordered

    @current = "sponsor"

    @sponsorships_email = SponsorshipEmail.new
  end

  def gifts
    @gifts = Gift.status.ordered
    @current = "gift"
  end

  def faq
    @current = "faq"
  end

  def promotion
    @email = Email.by_language(I18n.locale).find(DVDPost.email[:sponsorships_invitation])
    respond_to do |format|
      format.html
      format.js {render :layout => false}
    end
  end
end
