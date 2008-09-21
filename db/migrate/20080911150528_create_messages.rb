class CreateMessages < ActiveRecord::Migration
  
  def self.up
    create_table :messages do |t|
      t.timestamps
      t.string  :title ,:null => false
      t.string  :content,:null => false
      t.integer :user_id,:null => false
    end

  end

  def self.down
    drop_table :messages
  end

end
