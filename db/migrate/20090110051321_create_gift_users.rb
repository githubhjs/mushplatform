class CreateGiftUsers < ActiveRecord::Migration
  def self.up
    create_table :gift_users, :force => true, :options => "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
      t.integer  :user_id
      t.integer  :friend_id
      t.integer  :gift_id
      t.string   :post
      t.integer  :send_mode
      t.datetime :created_at
    end
  end

  def self.down
    drop_table :gift_users
  end
end
