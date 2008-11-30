class CreateTopics < ActiveRecord::Migration
  def self.up
    create_table :topics do |t|
      t.string  :title,:user_name,:null => false
      t.integer  :user_id,:user_group_id,:admin_id,:null => false
      t.integer :view_count,:comment_count,:default => 0
      t.text    :description
      t.timestamps
    end
  end

  def self.down
    drop_table :topics
  end
end
