class CustomerAboProcessStat < ActiveRecord::Base
  set_table_name :customers_aboprocess_stats

  alias_attribute :customer_id, :customers_id

  belongs_to :customer, :foreign_key => :customers_id

end