module MySpaceHelper

  def display_blog_admin_sex(profile = nil)
    profile ||= current_blog_user.user_profile
    if profile
      case profile.sex
      when Const::Sex_Unknown
        '保密'
      when Const::Sex_Woman
        '女'
      when Const::Sex_Man
        '男'
      end
    end
  end

  def url_f(paginate_html,url)
    return '' if paginate_html.blank?
    paginate_html.gsub!(/href=["'](\/page\/\d+)["']/) do |match|
      "href='#{url}#{$1}'"
    end
    paginate_html.gsub!(/['"](#{url}\/page)\/?["']/,'"\1/1"')
    paginate_html
  end
  
end
#s = <<s
# <span class="disabled prev_page">&lt;&lt;上一页</span> <span class="current">1</span>
# <a href="/page">2</a> <a href="/page/3">3</a>
# <a href="/page/4">4</a> <a href="/page/5">5</a> <a href="/page/6">6</a>
# <a href="/page/7">7</a> <a href="/page/2">下一页&gt;&gt;</a>
#s
#ss = s.gsub(/href="(\/page\/\d+)"/) do |match|
#  'href="/blogs/$1"'
#end
#puts ss

