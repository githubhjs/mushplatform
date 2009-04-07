class AddMuicToBlogConfig < ActiveRecord::Migration
  
  def self.up
    add_column :blog_configs,:music,:string
  end

  def self.down
    remove_column :blog_configs,:music
  end

end
