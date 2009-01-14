class AddUserProfilesIconMeta < ActiveRecord::Migration
  
  def self.up
    add_column :user_profiles, :avatar, :string

#    add_column :user_profiles, :size, :integer
#    add_column :user_profiles, :content_type, :string
#    add_column :user_profiles, :filename, :string

#    create_table :thumbnails do |t|
#      t.column :parent_id,  :integer
#      t.column :content_type, :string
#      t.column :filename, :string
#      t.column :thumbnail, :string
#      t.column :size, :integer
#      t.column :width, :integer
#      t.column :height, :integer
#    end

  end

  def self.down
    remove_column :user_profiles, :avatar
#    remove_column :user_profiles, :size
#    remove_column :user_profiles, :content_type
#    remove_column :user_profiles, :filename
#
#    drop_table :thumbnails
  end
end
