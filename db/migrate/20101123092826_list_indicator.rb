class ListIndicator < ActiveRecord::Migration
  def self.up
    create_table :customer_attributes do |t|
      t.integer :customer_id
      t.boolean :list_indictor_close, :default => 0
      t.integer :number_of_logins
      t.date    :last_login_at
      t.timestamps
    end
  end

  def self.down
    drop_table :customer_attributes
  end
end
