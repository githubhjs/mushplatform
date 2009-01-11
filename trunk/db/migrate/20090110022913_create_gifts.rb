class CreateGifts < ActiveRecord::Migration
  def self.up
    create_table :gifts, :force => true, :options => "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
      t.string :name_zh
      t.string :name_en
      t.integer :type , :default => 0
      t.string :icon
    end
  end

  def self.down
    drop_table :gifts
  end
end
