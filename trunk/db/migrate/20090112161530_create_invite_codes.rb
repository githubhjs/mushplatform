class CreateInviteCodes < ActiveRecord::Migration
  
  def self.up
    create_table :invite_codes do |t|
      t.integer :user_id,:null => false
      t.string  :invite_code,:null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :invite_codes
  end

end
