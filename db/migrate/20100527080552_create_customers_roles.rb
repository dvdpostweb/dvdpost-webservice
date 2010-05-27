class CreateCustomersRoles < ActiveRecord::Migration
  def self.up
    create_table :customers_roles, :id => false do |t|
      t.references :customer, :role
      t.timestamps
    end

    add_index :customers_roles, :role_id
    add_index :customers_roles, :customer_id
  end

  def self.down
    remove_index :customers_roles, :role_id
    remove_index :customers_roles, :customer_id

    drop_table :customers_roles
  end
end
