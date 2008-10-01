class BlogController < ApplicationController

  Blog_Count_PerPage =   1
  
  def dispatch
    user = current_blog_user
    path = params[:path]
    if path.index('entry')
      # /entry/1234
      content = recognize_entry(user, path)
    elsif path.index('category')
      # /category/mood
      content = recognize_category(user, path)
    elsif path.index('archives')
      # /archives/2008/10
      content = recognize_archives(user, path)
    elsif path.index('tag')
      # /tag/olympic
      content = recognize_archives(user, path)
    elsif path.index('search')
      # /search/olympic
      content = recognize_search(user, path)
    else
      # /
      content = recognize_entries(user, path)
    end
    render :text => parse_template(user.theme_name, 'layout').render('content' => content,'sidebar_content' => generate_sidebar_content(user)) 
  end
  
  protected
  def recognize_entries(user, path)
    if user
      page = path.index('page') ? path.delete_at(path.length-1) : params[:page]
      entries = Blog.publised_blogs.paginate(:page => page, :per_page => Blog_Count_PerPage,:conditions => "user_id=#{user.id}")
      content = parse_template(user.theme_name, 'entries').render('entries' => entries, 'page' => page, 'will_paginate_options' => {'prev_label' => '上一页','next_label' => '下一页'})
    else
      content = "Page Not Found"
    end
    return content
  end  

  def generate_sidebar_content(user)
    sidebar_infos = SidebarUser.user_sidebars(user.id).map{|bar|
      Sidebar.find(bar.sidebar_id)}.compact.map{|sidebar|sidebar.get_content(:user_id => user.id)}
    sidebar_infos.join('   ')
  end
  
  def recognize_entry(user, path)
    if user
      entry = Blog.publised_blogs.find(path.last.to_i)
      content = parse_template(user.theme_name, 'entry').render('entry' => entry)
    else
      content = "Page Not Found"
    end
    return content
  end  
  
  def parse_template(theme, template)
    theme_path = "#{Theme.themes_root}/#{theme}/templates"
    template_path = "#{theme_path}/#{template}.liquid"
    Liquid::Template.file_system = Liquid::LocalFileSystem.new(theme_path)
    Liquid::Template.parse(IO.read(template_path))
  end
  
  def current_blog_user
    User.find_by_user_name(request.subdomains.first)
  end
  
end
