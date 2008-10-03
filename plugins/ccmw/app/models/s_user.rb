class SUser < ActiveRecord::Base
  establish_connection "shadowfox" 
  set_table_name "users"  
 end
