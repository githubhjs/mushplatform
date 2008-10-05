class CreateProvinces < ActiveRecord::Migration
  def self.up
    create_table :provinces, :force => true, :options => "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
      t.integer :provinceid,:null => false
      t.string  :province
    end
  end

  def self.down
    drop_table :provinces
  end
end
