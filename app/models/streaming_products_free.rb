class StreamingProductsFree < ActiveRecord::Base
  set_table_name :streaming_products_free

  named_scope :available, lambda {{:conditions => ['available = ? and available_from < ? and streaming_products.expire_at > ?', 1, Time.now.to_s(:db), Time.now.to_s(:db)]}}
end
