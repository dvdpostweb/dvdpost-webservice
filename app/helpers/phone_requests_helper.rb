module PhoneRequestsHelper
  def reasons_translations
    {
      :promo_invalid => "Mon code promo ne fonctionne pas",
      :password_not_received => "Je nÕai pas reu de mot de passe",
      :payment => "Problme de paiement",
      :delivery => "Problme de livraison",
      :profile_update => "Mise ˆ jour de mon profil",
      :other => "Autre"
    }  
  end

  def reasons_collection_for_select
    options = []
    codes_hash = PhoneRequest.reason_codes
    codes_hash.each {|key, code| options.push [code, reasons_translations[key]]}
    options
  end

end
