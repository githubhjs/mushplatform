module Admin::AuthHelper
  class << self
    def add_mainmenu
      menu = "
        <li><a href='' id='authorize'>#{I18n.t 'text.menu.authorize'} &#187;<!--[if gte IE 7]><!--></a><!--<![endif]-->
            <!--[if lte IE 6]><table><tr><td><![endif]--><ul>
                    <li><a href='/admin/roles'>#{I18n.t 'text.menu.roles'}</a></li>
                    <li><a href='/admin/groups'>#{I18n.t 'text.menu.groups'}</a></li>
                    <li><a href='/admin/users'>#{I18n.t 'text.menu.users'}</a></li>
            </ul><!--[if lte IE 6]></td></tr></table></a><![endif]-->
        </li>"
    end  
    
  end
end
