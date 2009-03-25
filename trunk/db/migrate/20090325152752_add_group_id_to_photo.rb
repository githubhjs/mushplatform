class AddGroupIdToPhoto < ActiveRecord::Migration
  def self.up
    add_column :photos, :group_id,:integer,:default => 0
  end

  def self.down
    remove_column :group_id
  end
end
