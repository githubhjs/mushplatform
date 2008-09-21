class CreateGroups < ActiveRecord::Migration
  
  def self.up
    
    create_table :groups, :force => true, :options => "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
      t.string  :group_name,:null => false
      t.integer :status ,:null => false,:default => 0
      t.integer :inherit_group_id,:default => 0
      t.text    :description
      t.string  :theme_name
    end
    
  end

  def self.down
    drop_table :groups
  end
  
end
