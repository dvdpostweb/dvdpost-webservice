class CreatePartners < ActiveRecord::Migration
  def self.up
    drop_table :partners rescue puts "Table 'partners' doesn't exist so it couldn't be removed"
    create_table :partners do |t|
      t.string :name
      t.string :logo
      t.boolean :active
      t.timestamps
    end
  end

  def self.down
    drop_table :partners
  end
end
