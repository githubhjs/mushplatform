class CreateUsers < ActiveRecord::Migration
  
  def self.up
    create_table :users, :force => true, :options => "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
      t.string   :user_name,:hashed_password,:email,:salt,:null => false
      t.datetime :created_at
      t.integer  :status ,:null => false,:default => 0
      t.string   :pwd_question,:pwd_anwser,:default => ''
    end
  end

  def self.down
    drop_table :users
  end
  
end
