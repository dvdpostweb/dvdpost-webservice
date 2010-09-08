class AddQualityStreamingViewing < ActiveRecord::Migration
  def self.up
    add_column :streaming_viewing_histories, :quality, 'enum("HIGH", "LOW")'
  end

  def self.down
    remove_column :streaming_viewing_histories, :quality
  end
end
