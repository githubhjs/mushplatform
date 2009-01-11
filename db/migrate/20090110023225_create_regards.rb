class CreateRegards < ActiveRecord::Migration

  def self.up
    create_table :regards, :force => true, :options => "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
      t.string :name_zh
      t.string :name_en
      t.string :icon
    end
  end

  def self.down
    drop_table :regards
  end

end
