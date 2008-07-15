class MenubarToVersion20080713091547 < ActiveRecord::Migration
  def self.up
    Engines.plugins["menubar"].migrate(20080713091547)
  end

  def self.down
    Engines.plugins["menubar"].migrate(0)
  end
end
