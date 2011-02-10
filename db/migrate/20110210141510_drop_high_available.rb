class DropHighAvailable < ActiveRecord::Migration
  def self.up
    remove_column :streaming_products, :high_available
  end

  def self.down
    add_column :streaming_products, :high_available, :boolean, :default => 0
  end
end
