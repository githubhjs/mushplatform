module AuthHelper
  class << self
    def add_mainmenu
      <<menu
  <li><a href="#nogo">Authorize &#187;<!--[if gte IE 7]><!--></a><!--<![endif]-->
      <!--[if lte IE 6]><table><tr><td><![endif]--><ul>
              <li><a href="#nogo">Roles</a></li>
              <li><a href="#nogo">Groups</a></li>
              <li><a href="#nogo">Users</a></li>
      </ul><!--[if lte IE 6]></td></tr></table></a><![endif]-->
  </li>
menu
    end  
    
  end
end
