class CreateVoteOptions < ActiveRecord::Migration
  
  def self.up
    create_table :vote_options, :force => true, :options => "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
     t.integer :voter_id
     t.string :title
     t.integer :value
    end
  end

  def self.down
    drop_table :vote_options
  end
  
end
