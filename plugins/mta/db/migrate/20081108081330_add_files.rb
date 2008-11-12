class AddFiles < ActiveRecord::Migration
  def self.up
    create_table "files", :force => true, :options => "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
      t.string :name, :null => false
      t.string :type, :content_type, :filename, :path, :category
      t.integer :parent_id, :size, :width, :height
      t.timestamps
    end
  end

  def self.down
    remove_column "files"
  end
end
