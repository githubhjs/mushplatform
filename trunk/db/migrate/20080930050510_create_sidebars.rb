class CreateSidebars < ActiveRecord::Migration
  
  def self.up
    create_table :sidebars do |t|
      t.string  :bar_name,:null => false
      t.integer :user_id,:null =>  false
      t.integer :bar_index
      t.text    :description
      t.text    :settings
      t.integer :sidebar_id,:null => false
    end
  end

  def self.down
    drop_table :sidebars
  end
  
end
