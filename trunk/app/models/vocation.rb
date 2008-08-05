class Vocation < ActiveRecord::Base
  
  def self.all_vocations
    find(:all)
  end
end
