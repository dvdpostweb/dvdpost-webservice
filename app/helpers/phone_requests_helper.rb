module PhoneRequestsHelper
  def reasons_collection_for_select
    options = []
    codes_hash = PhoneRequest.reason_codes
    codes_hash.each {|key, code| options.push [code, t(".#{key}")]}
    options
  end

  def languages_collection_for_select
    options = []
    codes_hash = PhoneRequest.languages
    codes_hash.each {|key, code| options.push [t(".#{code}"), key]}
    options
  end
end
