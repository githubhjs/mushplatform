class CreateGiftUsers < ActiveRecord::Migration
  def self.up
    create_table :gift_users do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :gift_users
  end
end
