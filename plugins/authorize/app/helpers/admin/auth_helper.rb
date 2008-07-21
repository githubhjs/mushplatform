module Admin::AuthHelper
  class << self
    def add_mainmenu
      <<menu
  <li><a href="#nogo" id='authorize'>Authorize &#187;<!--[if gte IE 7]><!--></a><!--<![endif]-->
      <!--[if lte IE 6]><table><tr><td><![endif]--><ul>
              <li><a href="/admin/roles">Roles</a></li>
              <li><a href="/admin/groups">Groups</a></li>
              <li><a href="/admin/users">Users</a></li>
      </ul><!--[if lte IE 6]></td></tr></table></a><![endif]-->
  </li>
menu
    end  
    
  end
end
