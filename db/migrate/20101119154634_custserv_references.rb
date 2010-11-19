class CustservReferences < ActiveRecord::Migration
  def self.up
    create_table :custserv_references do |t|
      t.string :name
      t.integer :reference_id
      t.integer :message_id
      t.timestamps
    end
  end

  def self.down
    drop_table :partners
  end

end
