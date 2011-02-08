class AddQualityStreamingProducts < ActiveRecord::Migration
  def self.up
    add_column :streaming_products, :quality, 'enum("LOW", "HIGH", "HD")'
  end

  def self.down
    remove_column :streaming_products, :quality
  end
end
