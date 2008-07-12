#A demo to show how extend a exist extension point
#This extender should be regiestered for MenubarExtension by CmsExsension
module ExtendMenubarDemo
  
  class << self
    def add_menu_to_bar
      return "<a href='test'>Test</a>"
    end  
  end
  
end
