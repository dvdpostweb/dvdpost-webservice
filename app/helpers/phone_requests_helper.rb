module PhoneRequestsHelper
  def reasons_collection_for_select
    options = []
    codes_hash = PhoneRequest.reason_codes
    codes_hash.each {|key, code| options.push [code, t(".#{key}")]}
    options
  end

end
