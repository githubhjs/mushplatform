#A demo to show how extend a exist extension point
#This extension should be regiestered for MenubarExtension by CmsExsension

module AdminHelper
  
  class << self
    def add_mainmenu
      <<menu
  <li><a href="#nogo">CMS &#187;<!--[if gte IE 7]><!--></a><!--<![endif]-->
      <!--[if lte IE 6]><table><tr><td><![endif]--><ul>
              <li><a href="/admin/templates">Templates</a></li>
              <li><a href="#nogo">Columns</a></li>
              <li><a href="#nogo">Aritcles</a></li>
      </ul><!--[if lte IE 6]></td></tr></table></a><![endif]-->
  </li>
menu
      menu_bar
    end  
    
    def add_submenu
      <<menu
  <li><a href="/admin/templates">Templates</a></li>
  <li><a href="#nogo">Columns</a></li>
  <li><a href="#nogo">Aritcles</a></li>
menu
    end
  end
  
end
