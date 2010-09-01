class RenameTokenSourceUrlToFilename < ActiveRecord::Migration
  def self.up
    rename_column :tokens, :source_url, :filename
  end

  def self.down
    rename_column :tokens, :filename, :source_url
  end
end
