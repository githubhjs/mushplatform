class CreateActiveVotes < ActiveRecord::Migration

  def self.up
    
    create_table :active_votes do |t|

      t.integer :user_id,:null => false

      t.string  :user_name,:null => false

      t.string  :ip,:null => false

      t.text    :message

      t.integer :voter_id,:null => false,:default => 0
      
      t.datetime :created_at
      
    end

  end

  def self.down
    drop_table :active_votes
  end
  
end
