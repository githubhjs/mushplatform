class CreateUserGroups < ActiveRecord::Migration
  def self.up
    create_table :user_groups, :force => true, :options => "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
      t.string  :title,:user_name,:null => false
      t.integer :user_id,:null => false
      t.text    :description
      t.string  :icon,:category
      t.integer :topic_count,:default => 0
      t.integer :member_count,:default => 1
      t.timestamps
    end
  end

  def self.down
    drop_table :user_groups
  end
end
