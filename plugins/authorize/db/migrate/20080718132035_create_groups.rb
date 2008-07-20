class CreateGroups < ActiveRecord::Migration
  
  def self.up
    
    create_table :groups do |t|
      t.string  :group_name,:group_type,:null => false
      t.integer :status ,:null => false,:default => 0
    end
    
  end

  def self.down
    drop_table :groups
  end
  
end
