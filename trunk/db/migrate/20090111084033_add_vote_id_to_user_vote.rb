class AddVoteIdToUserVote < ActiveRecord::Migration
  def self.up
    add_column :user_votes,:vote_id,:integer,:null => false
  end

  def self.down
    remove_column :user_votes,:vote_id
  end
end
