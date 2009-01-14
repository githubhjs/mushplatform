class AddUserProfilesIconMeta < ActiveRecord::Migration
  
  def self.up
    add_column :user_profiles, :size, :integer
    add_column :user_profiles, :content_type, :string
    add_column :user_profiles, :filename, :string
    add_column :user_profiles, :height, :integer
    add_column :user_profiles, :width, :integer
  end

  def self.down
    remove_column :user_profiles, :size
    remove_column :user_profiles, :content_type
    remove_column :user_profiles, :filename
    remove_column :user_profiles, :height
    remove_column :user_profiles, :width
  end
end
