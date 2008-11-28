class MySpaceController < ApplicationController
  
  skip_before_filter :verify_authenticity_token,:only => [:create_comment]  
  
  include ControllerExtend
  
  Blog_Count_PerPage =   20

  Rss_Blog_Perppage = 20

  Comment_Count_PerPage = 50
  
  helper_method :current_blog_user  
  
  def index
    entries = Blog.publised_blogs.paginate(:page => params[:page]||1,:per_page => Blog_Count_PerPage, :conditions =>generate_conditions)
    blog_owner = is_blog_admin? ? current_user : nil
    render_liquid({:template => 'entries',:layout => true},{'entries' => entries,'blog_owner' => blog_owner,'will_paginate_options' => {'prev_label' => '上一页','next_label' => '下一页'}.merge(keep_params)})
  end

  def show
    @blog = Blog.find(params[:id])
    @blog.add_view_count
    @comments = @blog.comments.paginate(:page => params[:page]||1,:per_page => Comment_Count_PerPage,:order => "created_at")
    render_liquid({:template => 'entry',:layout => true},{'entry' => @blog,'if_login' => current_user ? true : false,'comments' => @comments ,'will_paginate_options' => {'prev_label' => '上一页','next_label' => '下一页',:page => params[:page]||1,:path => "#{request.path.gsub(/\/comments\/page\/\d+/,'')}/comments"}})
  end

  def create_comment
    if user = (current_user || (params[:user] && User.authenticate(params[:user][:user_name],params[:user][:password])))
      @comment = Comment.new(params[:comment])
      @comment.author = user.user_name
      @comment.email = user.email
      @comment.user_id = user.id
      @comment.blog_user_id = current_blog_user.id
      if @comment.save
        Blog.connection.execute("update blogs set comment_count = comment_count + 1 where id=#{@comment.blog_id}")
        content = parse_liquid('_comment',{'comment' => @comment })
        render :update do |page|
          page.insert_html :bottom, 'comments',content
        end
      else
        render :update do |page|
          page.replace_html 'erro_info',@comment.errors.full_messages.join(';')
          page['erro_info'].show
        end
      end
    else
      render :update do |page|
        page.replace_html 'erro_info', "用户名或者密码不对"
        page['erro_info'].show
      end
    end
  end

  def rss
    @blogs = Blog.publised_blogs.find(:all,:conditions => "user_id=#{current_blog_user.id}",:limit => Rss_Blog_Perppage)
    @user = current_blog_user
    render :content_type => "application/xml",:template => "/my_space/rss",:layout => 'rss'
  end

  protected
  
  def keep_params
    orignal_params = {}
    #    [:month,:date,:year,:keyword,:category_id,:tag].each do |attr|
    #      orignal_params[attr.to_s] = params[attr] unless params[attr].blank?
    #    end
    orignal_params['page'] = params[:page] || 1
    orignal_params[:path]  = request.path.gsub(/\/page\/\d+/,'')
    orignal_params
  end


  def generate_conditions
    conditions = ["user_id=#{current_blog_user.id}"]
    #如果是安月份查询
    if (!params[:month].blank? and !params[:year].blank?) and params[:date].blank? 
      m_dates = [31,28,31,30,31,30,31,31,30,31,30,31]
      limit_date  = Date.parse("#{params[:year]}-#{params[:month]}-1")
      max_date = limit_date + m_dates[limit_date.month-1] - 1
      conditions <<  "(created_at >= '#{limit_date}' and created_at <= '#{max_date}')"
    end
    #如果是按日期查询
    unless params[:year].blank? or params[:month].blank? or params[:date].blank?
      date = Date.parse("#{params[:year]}-#{params[:month]}-#{params[:date]}")
      conditions <<  "(created_at >= '#{date}' and created_at <= '#{date.next}')"
    end
    #如果是按照关键字搜索的
    unless params[:keyword].blank?
      conditions << Blog.generate_sql_from_arry(["(title like ? or body like ?  or keywords like ?)","%#{params[:keyword]}%","%#{params[:keyword]}%","%#{params[:keyword]}%"])
    end
    #如果是按照类别查询
    unless params[:category_id].blank?
      conditions << "category_id=#{params[:category_id]}"
    end
    #如果是按照tag管理
    unless params[:tag].blank?
      tag = Tag.find(params[:tag])
      conditions << "id in (select taggable_id from taggings where tag_id=#{tag.id})"
    end
    conditions.join(' and  ')
  end
  
end
