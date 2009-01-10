class AddFootsteps < ActiveRecord::Migration
  def self.up
    create_table :footsteps, :force => true, :options => "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
      t.integer :user_id
      t.string :app, :content
      t.timestamps
    end
  end

  def self.down
    drop_table :footsteps
  end
end
