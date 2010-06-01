class PhoneRequest < ActiveRecord::Base
  set_table_name :phone_request

  def self.reason_codes
    codes = OrderedHash.new ()
    codes.push(:promo_invalid, 0)
    codes.push(:password_not_received, 1)
    codes.push(:payment, 2)
    codes.push(:delivery, 3)
    codes.push(:profile_update, 5)
    codes.push(:other, 6)
    codes
  end
end