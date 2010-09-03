class AddStreamingViewingHistory < ActiveRecord::Migration
    def self.up
      create_table :streaming_viewing_histories do |t|
        t.integer :streaming_product_id
        t.enum :quality, :limit => [:HIGH, :LOW]
        t.integer :token_id
        t.timestamps
      end
    end

    def self.down
      drop_table :streaming_viewing_histories
    end
  end
