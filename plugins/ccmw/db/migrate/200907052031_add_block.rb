class AddBlock < ActiveRecord::Migration
  def self.up
    create_table "blocks", :options => "ENGINE=MyISAM DEFAULT CHARSET=utf8", :force => true do |t|
      t.column "name", :string
      t.column "tags", :text
    end
  end

  def self.down
    drop_table "blocks"
  end
end
