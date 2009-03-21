class CreateVisitors < ActiveRecord::Migration
  
  def self.up

    create_table :visitors do |t|
      t.integer :visitor_id,:user_id,:null => false
      t.string  :visitor_real_name,:visitor_name
      t.timestamps
    end

  end

  def self.down
    drop_table :visitors
  end
  
end
