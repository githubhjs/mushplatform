class AuthorizeToVersion20080720032627 < ActiveRecord::Migration
  def self.up
    Engines.plugins["authorize"].migrate(20080720032627)
  end

  def self.down
    Engines.plugins["authorize"].migrate(0)
  end
end
