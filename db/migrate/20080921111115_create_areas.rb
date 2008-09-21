class CreateAreas < ActiveRecord::Migration
  def self.up
    create_table :areas do |t|
      t.integer :areaid ,:father_id,:null => false
      t.string  :area,:null => false
    end
  end

  def self.down
    drop_table :areas
  end
end
