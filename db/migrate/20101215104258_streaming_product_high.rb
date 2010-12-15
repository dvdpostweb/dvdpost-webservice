class StreamingProductHigh < ActiveRecord::Migration
  def self.up
    add_column :streaming_products, :high_available, :boolean, :default => 0
  end

  def self.down
    remove_column :streaming_products, :high_available
  end
end
