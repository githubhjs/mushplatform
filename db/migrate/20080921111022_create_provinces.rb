class CreateProvinces < ActiveRecord::Migration
  def self.up
    create_table :provinces do |t|
      t.integer :provinceid,:null => false
      t.string  :province
    end
  end

  def self.down
    drop_table :provinces
  end
end
