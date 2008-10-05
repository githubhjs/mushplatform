class CreateSidebars < ActiveRecord::Migration
  
  def self.up
    create_table :sidebars, :force => true, :options => "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
      t.string  :bar_name,:null => false
      t.integer :user_id,:null =>  false
      t.integer :bar_index
      t.text    :description
      t.text    :settings
      t.string :sidebar_id,:null => false
    end
  end

  def self.down
    drop_table :sidebars
  end
  
end
