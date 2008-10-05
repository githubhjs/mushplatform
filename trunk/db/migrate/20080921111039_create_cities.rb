class CreateCities < ActiveRecord::Migration
    
  def self.up
    create_table :cities, :force => true, :options => "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
      t.integer :city_id,:father_id,:null => false
      t.string  :city
    end
  end

  def self.down
    drop_table :cities
  end
  
end
