class ProductView < ActiveRecord::Migration
  def self.up
    create_table :product_views do |t|
      t.references :product
      t.integer :number
      t.timestamps
    end

    add_index :product_views, :product_id
  end

  def self.down
    remove_index :product_views, :product_id

    drop_table :product_views
  end
end
