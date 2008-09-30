class BlogController < ApplicationController
  Blog_Count_PerPage =   1
  
  def dispatch
    user = current_blog_user
    path = params[:path]
    if path.index('entry')
      content = recognize_entry(user, path)
    elsif path.index('category')
      content = recognize_category(user, path)
    elsif path.index('archives')
      content = recognize_archives(user, path)
    elsif path.index('search')
      content = recognize_search(user, path)
    else
      content = recognize_entries(user, path)
    end
    render :text => parse_template(user.theme_name, 'layout').render('content' => content) 
  end
  
  protected
  def recognize_entries(user, path)
    if user
      page = path.index('page') ? path.delete_at(path.length-1) : params[:page]
      entries = Blog.publised_blogs.paginate_by_user_id user.id, :page => page, :per_page => Blog_Count_PerPage
      content = parse_template(user.theme_name, 'entries').render('entries' => entries, 'page' => page, 'will_paginate_options' => {'prev_label' => '上一页','next_label' => '下一页'})
    else
      content = "Page Not Found"
    end
    return content
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
