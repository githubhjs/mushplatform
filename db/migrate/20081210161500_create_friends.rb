class CreateFriends < ActiveRecord::Migration
  def self.up
    create_table :friends, :id => false, :force => true, :options => "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
      t.integer :user_id, :friend_id
      t.timestamps
    end
    add_index :friends, [:user_id, :friend_id], :unique => true
  end

  def self.down
    drop_table :friends
  end
end
