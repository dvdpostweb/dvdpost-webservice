class PhoneRequest < ActiveRecord::Base
  set_table_name :phone_request
  
  belongs_to :customer,         :foreign_key => :customers_id

  validates_presence_of :name
  validates_presence_of :phone
  
  validates_presence_of :call_me_reason

  def self.time_slots
    slots = OrderedHash.new
    slots.push("9h00 - 9h30", 1)
    slots.push("9h30 - 10h00", 2)
    slots.push("10h00 - 10h30", 3)
    slots.push("10h30 - 11h00", 4)
    slots.push("11h00 - 11h30", 5)
    slots.push("11h30 - 12h00", 6)
    slots.push("12h00 - 12h30", 7)
    slots.push("12h30 - 13h00", 8)
    slots.push("13h00 - 13h30", 9)
    slots.push("13h30 - 14h00", 10)
    slots.push("14h00 - 14h30", 11)
    slots.push("14h30 - 15h00", 12)
    slots.push("15h00 - 15h30", 13)
    slots.push("15h30 - 16h00", 14)
    slots.push("16h00 - 16h30", 15)
    slots.push("16h30 - 17h00", 16)
    slots
  end

  def self.reason_codes
    codes = OrderedHash.new
    codes.push(:promo_invalid, 0)
    codes.push(:password_not_received, 1)
    codes.push(:payment, 2)
    codes.push(:delivery, 3)
    codes.push(:profile_update, 5)
    codes.push(:other, 6)
    codes
  end

  def self.languages
    lang = OrderedHash.new
    lang.push(1, :fr)
    lang.push(2, :nl)
    lang.push(3, :en)
    lang
  end

  def requested_date
    (call_me_day == 0 ) ? nil : Time.at(call_me_day).strftime("%m/%d/%Y")
  end

  def requested_date=(date)
    if date.nil?
        0 
    else
      regex = /\d{2}\/\d{2}\/\d{4}/
      if date =~ regex
        self.call_me_day = Time.parse(date).to_i
      else
        0
      end
    end
  end
end