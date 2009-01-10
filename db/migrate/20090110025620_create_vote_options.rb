class CreateVoteOptions < ActiveRecord::Migration
  
  def self.up
    create_table :vote_options do |t|
     t.integer :voter_id
     t.integer :title
     t.integer :value
    end
  end

  def self.down
    drop_table :vote_options
  end
  
end
