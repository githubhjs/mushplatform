class CreateUserProfiles < ActiveRecord::Migration
  
  def self.up
    create_table :user_profiles, :force => true, :options => "ENGINE=MyISAM DEFAULT CHARSET=utf8" do |t|
      t.string   :real_name
      t.integer  :user_id,:null => false
      t.string   :photo
      t.text     :adress,:introduction,:default => ''
      t.string   :company_name,:position,:zipcode
      t.string   :tel,:mobile,:fax
      t.string   :web_site
      t.integer  :vocation_id
      t.integer  :company_nature,:interested
      t.timestamps
    end
  end

  def self.down
    drop_table :user_profiles
  end
end
