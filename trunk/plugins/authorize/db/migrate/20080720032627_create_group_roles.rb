class CreateGroupRoles < ActiveRecord::Migration
  def self.up
    create_table :group_roles do |t|
      t.integer :group_id,:role_id ,:null => false
    end
  end

  def self.down
    drop_table :group_roles
  end
end
