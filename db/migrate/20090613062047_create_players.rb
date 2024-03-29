class CreatePlayers < ActiveRecord::Migration
  def self.up
    create_table :players do |t|
      t.integer  :user_id,:null => false
      t.string   :real_name,:user_name,:null => false
      t.integer  :blog_count,:comment_count,:vote_count,:photo_count,:default => 0
      t.integer  :user_type,:has_image,:default => 0
      t.datetime :created_at
    end
  end

  def self.down
    drop_table :players
  end
end
