class ProductAboOrdered < ActiveRecord::Migration
  def self.up
    add_column :products_abo, :ordered, :integer, :default => 0
  end

  def self.down
    remove_column :products_abo, :ordered
  end
end
