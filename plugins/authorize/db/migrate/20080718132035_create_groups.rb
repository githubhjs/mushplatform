class CreateGroups < ActiveRecord::Migration
  
  def self.up
    create_table :groups do |t|
      t.string  :group_name,:null => false
      t.integer :group_type,:null => false,:default => 0
    end
  end

  def self.down
    drop_table :groups
  end
  
end
