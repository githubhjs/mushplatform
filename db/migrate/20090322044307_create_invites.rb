class CreateInvites < ActiveRecord::Migration
  
  def self.up
    create_table :invites do |t|
      t.integer :invitor_id,:user_id,:null => false
      t.string  :invitor_real_name,:invitor_name
      t.integer :status,:default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :invites
  end
  
end
