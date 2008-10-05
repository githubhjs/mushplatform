class CreatePersonalSidebars < ActiveRecord::Migration
  def self.up
    create_table :personal_sidebars, :force => true, :options => "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
      t.string     :title,     :null => false
      t.text       :template,  :null => false
      t.text       :description
      t.integer    :bar_index,:default => 0
    end
  end

  def self.down
    drop_table :personal_sidebars
  end
  
end
