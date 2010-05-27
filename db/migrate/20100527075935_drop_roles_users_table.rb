class DropRolesUsersTable < ActiveRecord::Migration
  def self.up
    remove_index :roles_users, :role_id
    remove_index :roles_users, :user_id

    drop_table :roles_users
  end

  def self.down
    create_table :roles_users, :id => false do |t|
      t.references :role, :user
      t.timestamps
    end

    add_index :roles_users, :role_id
    add_index :roles_users, :user_id
  end
end
