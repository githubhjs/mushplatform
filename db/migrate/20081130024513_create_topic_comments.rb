class CreateTopicComments < ActiveRecord::Migration
  
  def self.up
    create_table :topic_comments do |t|
      t.integer :topic_id,:null => false
      t.integer :user_id,:null => false
      t.string  :user_name,:null => false
      t.string  :title,:null => false
      t.text    :content
      t.timestamps
    end
  end

  def self.down
    drop_table :topic_comments
  end
  
end
