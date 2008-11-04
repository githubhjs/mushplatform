module MushAdminHelper
  class << self
    def add_mainmenu
      menu = "
        <li><a href='/admin/scriptlets' id='scriptlets'>#{I18n.t 'text.menu.scriptlets'} &#187;<!--[if gte IE 7]><!--></a><!--<![endif]-->
            <!--[if lte IE 6]><table><tr><td><![endif]--><ul>
                    <li><a href='/admin/scriptlets'>#{I18n.t 'text.menu.scriptlets'}</a></li>
            </ul><!--[if lte IE 6]></td></tr></table></a><![endif]-->
        </li>"
      menu
    end    
  end
end
