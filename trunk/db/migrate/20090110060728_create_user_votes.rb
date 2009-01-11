class CreateUserVotes < ActiveRecord::Migration

  def self.up
    create_table :user_votes, :force => true, :options => "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
      t.integer :voter_id
      t.integer :vote_value
      t.datetime :created_at
    end
  end

  def self.down
    drop_table :user_votes
  end
  
end
