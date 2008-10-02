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
      entries = Blog.publised_blogs.paginate(:page => page, :per_page => Blog_Count_PerPage,:conditions => generate_conditions)
      content = parse_template(user.theme_name, 'entries').render('entries' => entries, 'page' => page, 'will_paginate_options' => {'prev_label' => '上一页','next_label' => '下一页'})
    else
      content = "Page Not Found"
    end
    return content
  end  

  
  def generate_sidebar_content(user)
    sidebar_infos = SidebarUser.user_sidebars(user.id).map{|bar|
      Sidebar.find(bar.sidebar_id)}.compact.map{|sidebar|sidebar.get_content(sidebar_options())}
    sidebar_infos.join('   ')
  end
  
  def sidebar_options
    options = {:user_id => current_blog_user.id}
    options[:month] = params[:month] unless params[:month].blank?
    options[:date]  = params[:date]  unless params[:month].blank?
    options
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
    @user ||= User.find_by_user_name(request.subdomains.first)
  end
  
  def generate_conditions
    conditions = ["user_id=#{current_blog_user.id}"]
    #如果是安月份查询
    unless params[:month].blank?
      m_dates = [31,28,31,30,31,30,31,31,30,31,30,31]
      limit_date  = Date.parse(params[:month])
      max_date = limit_date + m_dates[limit_date.month-1] - 1
      conditions <<  "(updated_at >= '#{limit_date}' and updated_at <= '#{max_date}')"
    end
    #如果是按日期查询
    unless params[:date].blank?
      date = Date.parse(params[:date])
      conditions <<  "(updated_at >= '#{date}' and updated_at <= '#{date.next}')"
    end
    #如果是按照关键字搜索的
    unless params[:keyword].blank?
      conditions << Blog.generate_sql_from_arry(["(title like ? or body like ?  or keywords like ?)","%#{params[:keyword]}%"],"%#{params[:keyword]}%","%#{params[:keyword]}%")
    end
    #如果是按照类别查询
    unless params[:category_id].blank?
      conditions << "category_id=#{params[:category_id]}"
    end
    #如果是按照tag管理
    unless params[:tag].blank?
      conditions << ["keywords like ?","%#{params[:tag]}%"]
    end
    conditions.join(' and  ')
  end
end
