class ProductListAddLanguage < ActiveRecord::Migration
  def self.up
    add_column :product_lists, :language, :int, :default => 1
  end

  def self.down
    remove_column :product_lists, :language
  end
end
