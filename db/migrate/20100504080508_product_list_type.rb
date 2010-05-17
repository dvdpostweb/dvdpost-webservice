class ProductListType < ActiveRecord::Migration
  def self.up
    add_column :product_lists, :kind, 'enum("TOP", "THEME")'
  end

  def self.down
    remvove_column :product_lists, :kind
  end
end
