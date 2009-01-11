class CreateRegardUsers < ActiveRecord::Migration

  def self.up
    create_table :regard_users do |t|
      t.integer :user_id
      t.integer :friend_id
      t.integer :regard_id
      t.string  :post
      t.integer :send_mode
      t.timestamps
    end
  end

  def self.down
    drop_table :regard_users
  end
  
end
