class CreateGifts < ActiveRecord::Migration
  def self.up
    create_table :gifts do |t|
      t.string :name
      t.integer :type , :default => 0
      t.string :icon
    end
  end

  def self.down
    drop_table :gifts
  end
end
