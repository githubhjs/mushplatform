class CreateGroups < ActiveRecord::Migration
  
  def self.up
    
    create_table :groups do |t|
      t.string  :group_name,:null => false
      t.integer :status ,:null => false,:default => 0
      t.text    :description
    end
    
  end

  def self.down
    drop_table :groups
  end
  
end
