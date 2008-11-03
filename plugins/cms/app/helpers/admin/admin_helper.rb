#A demo to show how extend a exist extension point
#This extension should be regiestered for MenubarExtension by CmsExsension

module AdminHelper
  
  class << self
    def add_mainmenu
      menu = "
  <li><a href='/admin/articles?standalone=true' id='articles'>#{I18n.t 'text.menu.articles'} &#187;<!--[if gte IE 7]><!--></a><!--<![endif]-->
      <!--[if lte IE 6]><table><tr><td><![endif]--><ul>
              <li><a href='/admin/articles/new?standalone=true'>#{I18n.t 'text.menu.new'}</a></li>
              <li><a href='/admin/articles?standalone=true'>#{I18n.t 'text.menu.articles'}</a></li>
      </ul><!--[if lte IE 6]></td></tr></table></a><![endif]-->
  </li>
  <li><a href='/admin/channels' id='cms'>#{I18n.t 'text.menu.cms'} &#187;<!--[if gte IE 7]><!--></a><!--<![endif]-->
      <!--[if lte IE 6]><table><tr><td><![endif]--><ul>
              <li><a href='/admin/channels'>#{I18n.t 'text.menu.channels'}</a></li>
              <li><a href='/admin/templates'>Templates</a></li>
              <li><a href='/admin/assets'>Assets</a></li>
              <li><a href='/admin/articles?standalone=true'>Aritcles</a></li>
      </ul><!--[if lte IE 6]></td></tr></table></a><![endif]-->
  </li>"
      
    end  
    
    def add_submenu
      <<menu
  <li><a href='/admin/channels'>Channels</a></li>
  <li><a href='/admin/templates'>Templates</a></li>
  <li><a href='/admin/assets'>Assets</a></li>
  <li><a href='/admin/articles'>Aritcles</a></li>
menu
    end
  end
  
end
