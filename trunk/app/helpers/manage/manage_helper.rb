module Manage::ManageHelper
  
  def url_f(paginate_html,url)
    paginate_html.gsub!(/href=["']\/page\/(\d+)["']/) do |match|
      "href='#{url}?page=#{$1}'"
    end
    paginate_html
  end

end
