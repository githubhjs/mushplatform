class CreateAreas < ActiveRecord::Migration
  def self.up
    create_table :areas, :force => true, :options => "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
      t.integer :areaid ,:father_id,:null => false
      t.string  :area,:null => false
    end
  end

  def self.down
    drop_table :areas
  end
end
