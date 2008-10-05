class CreateCallers < ActiveRecord::Migration
  def self.up
    create_table :callers, :force => true, :options => "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :callers
  end
end
