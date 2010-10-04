class LanguageRenameAddShort < ActiveRecord::Migration
  def self.up
    rename_column :products_languages, :code, :short
  end

  def self.down
    rename_column :products_languages, :short, :code
  end
end
