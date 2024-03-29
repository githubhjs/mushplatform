class AddLinks < ActiveRecord::Migration
  def self.up
    create_table "links", :options => "ENGINE=MyISAM DEFAULT CHARSET=utf8", :force => true do |t|
      t.string :name, :url, :category
      t.text :memo
    end

    add_index "links", :name
    add_index "links", :category
  end

  def self.down
    drop_table "links"
  end
end
