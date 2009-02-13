class AddColumnToPhoto < ActiveRecord::Migration
  def self.up
    add_column :photos,:updated_at,:datetime
    add_column :photos,:max_link,:string,:null => false
    Photo.connection.execute("update photos set max_link = orignal_link")
  end

  def self.down
    remove_column :photos,:updated_at
    remove_column :photos,:max_link
  end
end
