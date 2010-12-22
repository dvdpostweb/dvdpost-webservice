class CreateCableOrder < ActiveRecord::Migration
  def self.up
    create_table :cable_orders do |t|
      t.references :customer
      t.string :name
      t.boolean :sent
      t.timestamps
    end

    add_index :cable_orders, :customer_id
  end

  def self.down
    remove_index :cable_orders, :customer_id

    drop_table :cable_orders
  end
end
