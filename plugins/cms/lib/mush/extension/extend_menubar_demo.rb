#A demo to show how extend a exist extension point
#This extender should be regiestered for MenubarExtension by CmsExsension
module ExtendMenubarDemo
  
  class << self
    def add_menu_to_bar
      menu_bar = <<menu
      <li><a class="hide" href="">Extended by cms</a>
       <ul>
        <li><a href="" >cms menu1</a></li>
        <li><a href="" >cms menu2</a></li>
        <li><a href="#">cms menu3</a></li>
       </ul>
      </li>
menu
      menu_bar
    end  
  end
  
end
