class LanguageAddShortName < ActiveRecord::Migration
  def self.up
    add_column :products_undertitles, :short, :string
  end

  def self.down
    remove_column :products_undertitles, :short
  end
end
