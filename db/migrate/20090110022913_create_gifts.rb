class CreateGifts < ActiveRecord::Migration
  def self.up
    create_table :gifts do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :gifts
  end
end
