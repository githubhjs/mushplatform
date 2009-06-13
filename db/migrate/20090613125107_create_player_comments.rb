class CreatePlayerComments < ActiveRecord::Migration
  
  def self.up
    
    create_table :player_comments do |t|
      t.integer  :user_id,:player_id,:null => false
      t.string   :user_name,:real_name,:null => false
      t.text     :content
      t.datetime :created_at
    end

  end

  def self.down
    drop_table :player_comments
  end
  
end
