class CreateRegards < ActiveRecord::Migration
  def self.up
    create_table :regards do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :regards
  end
end
