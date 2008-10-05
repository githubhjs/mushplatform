class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments, :force => true, :options => "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
      t.integer  :blog_id,:null => false
      t.string   :title,:author,:email,:url,:ip
      t.text     :body,:body_html,:text
      t.datetime :created_at,:updated_at
      t.integer  :user_id,:null => false
    end
  end

  def self.down
    drop_table :comments
  end
  
end
