class AboProcess < ActiveRecord::Base
  set_table_name :aboprocess_stats

  set_primary_key :aboprocess_id

  alias_attribute :customer_id, :customers_id

  named_scope :today,  lambda {{:conditions => {:date_start => Time.now.midnight..(Time.now.end_of_day)}}}
end