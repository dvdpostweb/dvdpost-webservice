class AddCustomersToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :customer_id, :int
  end

  def self.down
    remove_column :users, :customer_id
  end
end
