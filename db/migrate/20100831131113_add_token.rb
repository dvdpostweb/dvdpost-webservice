class AddToken < ActiveRecord::Migration
  def self.up
    create_table :tokens do |t|
      t.string :token
      t.string :ip
      t.string :source_url
      t.date   :expires_at
      t.timestamps
    end
  end

  def self.down
    drop_table :tokens
  end
end
