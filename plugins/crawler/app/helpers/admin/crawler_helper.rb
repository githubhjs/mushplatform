module CrawlerHelper
  class << self
    def add_crawlermenu
      <<menu
  <li><a href="#nogo" id='crawler'>Crawler &#187;<!--[if gte IE 7]><!--></a><!--<![endif]-->
      <!--[if lte IE 6]><table><tr><td><![endif]--><ul>
              <!--li><a href="/admin/mush_crawlers">Manage Crawler</a></li-->
              <li><a href="/admin/sites">Manage Site</a></li>
      </ul><!--[if lte IE 6]></td></tr></table></a><![endif]-->
  </li>
menu
    end  
    
  end
end
