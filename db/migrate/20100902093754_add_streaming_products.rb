class AddStreamingProducts < ActiveRecord::Migration
  def self.up
    create_table :streaming_products do |t|
      t.integer :imdb_id
      t.string :filename
      t.date :available_from
      t.date :expire_at
      t.boolean :available
      t.integer :language_id
      t.integer :subtitle_id
      t.timestamps
    end
  end

  def self.down
    drop_table :streaming_products
  end
end
