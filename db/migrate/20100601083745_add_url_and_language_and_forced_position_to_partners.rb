class AddUrlAndLanguageAndForcedPositionToPartners < ActiveRecord::Migration
  def self.up
    change_table(:partners) do |t|
      t.string :url
      t.string :language
      t.integer :forced_position
    end
  end

  def self.down
    change_table(:partners) do |t|
      t.remove :url
      t.remove :language
      t.remove :forced_position
    end
  end
end
