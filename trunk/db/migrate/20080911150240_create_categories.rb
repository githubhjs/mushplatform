class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories, :force => true, :options => "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
      t.string :name
      t.integer :user_id,:null => false
    end
  end

  def self.down
    drop_table :categories
  end
  
end
