class CreateVotes < ActiveRecord::Migration
  
  def self.up
    create_table :votes do |t|
      t.integer  :user_id,:null => false
      t.string   :title
      t.integer  :multi_selcect,:default => 1
      t.integer  :sex_limit,:default => 0
      t.integer  :roll_limt,:default => 0
      t.datetime :expire_time
      t.text     :description
      t.timestamps
    end
  end

  def self.down
    drop_table :votes
  end

end
