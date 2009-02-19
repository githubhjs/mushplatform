class AddViewcountToBlogconfig < ActiveRecord::Migration
  def self.up
    add_column :blog_configs, :view_count, :int, :default => 0
  end

  def self.down
    remove_column :blog_configs, :view_count
  end
end
