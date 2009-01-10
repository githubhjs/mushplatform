class CreateUserVotes < ActiveRecord::Migration

  def self.up
    create_table :user_votes do |t|
      t.integer :voter_id
      t.integer :vote_value
      t.datetime :created_at
    end
  end

  def self.down
    drop_table :user_votes
  end
  
end
