map.with_options(:conditions => {:method => :get}) do |get|  
  get.with_options(:controller => 'themes', :filename => /.*/, :conditions => {:method => :get}) do |theme|  
    theme.connect 'stylesheets/theme/:filename', :action => 'stylesheets'  
    theme.connect 'javascripts/theme/:filename', :action => 'javascript'  
    theme.connect 'images/theme/:filename', :action => 'images'  
  end  
end  
