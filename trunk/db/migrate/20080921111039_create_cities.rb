class CreateCities < ActiveRecord::Migration
    
  def self.up
    create_table :cities do |t|
      t.integer :city_id,:father_id,:null => false
      t.string  :city
    end
  end

  def self.down
    drop_table :cities
  end
  
end
