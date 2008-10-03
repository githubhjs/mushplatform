class SLinkword < ActiveRecord::Base
  establish_connection "shadowfox" 
  set_table_name "linkwords"
  
  has_and_belongs_to_many :blocks
  acts_as_tree
end
