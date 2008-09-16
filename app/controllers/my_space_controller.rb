class MySpaceController < ApplicationController
 
  before_filter :is_space_admin?
  
  def site_index
    
  end

  def manage_index

  end

end
