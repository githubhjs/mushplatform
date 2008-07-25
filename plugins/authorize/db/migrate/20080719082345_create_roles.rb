class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table :roles do |t|
      t.string  :role_name,:e_name,:null => false
      t.text    :description
      t.integer  :status ,:null => false,:default => 0
    end
  end

  def self.down
    drop_table :roles
  end
end
