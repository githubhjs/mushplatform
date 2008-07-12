class CreateMenuBars < ActiveRecord::Migration
  def self.up
    create_table :menu_bars do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :menu_bars
  end
end
