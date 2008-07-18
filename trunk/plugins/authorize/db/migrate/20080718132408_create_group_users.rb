class CreateGroupUsers < ActiveRecord::Migration
  def self.up
    create_table :group_users do |t|
      t.integer :group_id,:user_id,:null => false
    end
  end

  def self.down
    drop_table :group_users
  end
end
