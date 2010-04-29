class ProductLists < ActiveRecord::Migration
  def self.up
    create_table :product_lists do |t|
      t.string :name
      t.string :description
      t.boolean :home_page
      t.boolean :status
      t.timestamps
    end
    create_table :listed_products do |t|
      t.references :product
      t.references :product_list
      t.integer :order
      t.timestamps
    end
    add_index :listed_products, [:product_id, :product_list_id]
  end

  def self.down
    drop_table :product_lists
    drop_table :listed_products
  end
end
