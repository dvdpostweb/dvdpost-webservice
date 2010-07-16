module SuspensionsHelper
  def duration_collection_for_select
    options = []
    codes_hash = Suspension.duration
    codes_hash.each {|key, code| options.push [t(".#{code}"), key]}
    options
  end

end