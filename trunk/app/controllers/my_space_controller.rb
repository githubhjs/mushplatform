class MySpaceController < ApplicationController
  
  skip_before_filter :verify_authenticity_token,:only => [:create_comment]  
 
  include ControllerExtend

  layout :theme_layout
  
  Blog_Count_PerPage =   10
  Rss_Blog_Perppage = 20
  Comment_Count_PerPage = 50
  Photo_PerPage = 20
  Latest_Votes_Count = 5
  Latest_Blogs_Count = 5
  Latest_Photos_Count = 4
  Latest_Groups_Count = 5
  Latest_Friends_Count = 6
  Hot_Blog_Count = 10
  Latest_Messages_Count = 20
  Latest_Friends_Count  = 24
  Latest_Votes_Count = 20
  Latest_Groups_Count = 10
  
  helper_method :current_blog_user  

  before_filter :setup_theme
 
  def index
    BlogConfig.add_view_count(current_blog_user.id)
    unless current_theme.is_sns_theme?
      general_blog_index
    else
      sns_index
    end
    return 
  end

  def general_blog_index
    entries = Blog.publised_blogs.paginate(:page => params[:page]||1,:per_page => Blog_Count_PerPage, :conditions =>generate_conditions)
    blog_owner = is_blog_admin? ? current_user : nil
    render_liquid({:template => 'entries',:layout => true},{'entries' => entries,'blog_owner' => blog_owner,'will_paginate_options' => {'prev_label' => '上一页','next_label' => '下一页'}.merge(keep_params)})
  end

  def sns_index
    @votes        =  current_blog_user.votes.find(:all,:limit => Latest_Votes_Count,:order => 'id desc')
    @blogs        =  current_blog_user.blogs.find(:all,:limit => Latest_Blogs_Count,:conditions => "published = #{Blog::Published_Blogs}",:order => 'if_top desc,id desc')
    @photos       =  current_blog_user.photos.find(:all,:limit => Latest_Photos_Count,:order => 'id desc')
    @message      =  current_blog_user.messages.find(:first,:order => 'id desc')
    @friends      =  current_blog_user.friends.find(:all,:limit => Latest_Friends_Count,:order => 'id desc')
    @user_groups  =  current_blog_user.user_groups.find(:all,:limit => Latest_Groups_Count,:order => 'id desc')
    stat_info()
    render :template => 'index'
  end
  
  def blogs
    @categories = current_blog_user.categories
    @hot_blogs = Blog.publised_blogs.find(:all,:limit => Hot_Blog_Count,:order => "comment_count desc, view_count desc",:conditions => "user_id=#{current_blog_user.id}")
    @blogs = Blog.publised_blogs.paginate(:page => params[:page]||1,:per_page => Blog_Count_PerPage, :conditions => generate_conditions,:order => 'if_top desc,id desc')
    stat_info()
    render :template => 'blogs'
  end

  protected :sns_index,:general_blog_index
  
  def show
    BlogConfig.add_view_count(current_blog_user.id)
    @blog = Blog.find(params[:id])
    @blog.add_view_count
    @comments = @blog.comments.paginate(:page => params[:page]||1,:per_page => Comment_Count_PerPage,:order => "created_at")
    unless current_theme.is_sns_theme?
      render_liquid({:template => 'entry',:layout => true},{'entry' => @blog,'if_login' => current_user,'comments' => @comments ,'will_paginate_options' => {'prev_label' => '上一页','next_label' => '下一页',:page => params[:page]||1,:path => "#{request.path.gsub(/\/comments\/page\/\d+/,'')}/comments"}})
    else
      stat_info
      @categories = current_blog_user.categories
      @hot_blogs = Blog.publised_blogs.find(:all,:limit => Hot_Blog_Count,:order => "comment_count desc, view_count desc")
      render :template => 'blog'
    end
    return 
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
        unless current_theme.is_sns_theme?
          content = parse_liquid('_comment',{'comment' => @comment })
          render :update do |page|
            page.insert_html :bottom, 'comments',content
          end
        else
          render :update do |page|
            page.insert_html :bottom, 'comments',:partial => "/share/comment",:locals => {:comment => @comment }
          end
        end
      else
        render :update do |page|
          page.replace_html 'erro_info',@comment.errors.full_messages.join(';')
          page['erro_info'].show
        end
      end
    else
      render :update do |page|
        page.replace_html 'erro_info', "没有登陆或者用户名或和密码不对"
        page['erro_info'].show
      end
    end
  end

  def rss
    @blogs = Blog.publised_blogs.find(:all,:conditions => "user_id=#{current_blog_user.id}",:limit => Rss_Blog_Perppage)
    @user = current_blog_user
    render :content_type => "application/xml",:template => "/my_space/rss",:layout => 'rss'
  end


  def photos
    @photos = Photo.user_photos(current_blog_user.id).paginate(:page => params[:page],:per_page => Photo_PerPage,:order => "id desc")
    unless current_theme.is_sns_theme?
      render_liquid({:template => 'photos',:layout => true},{'photos' => @photos,'if_login' => current_user ? true : false,'comments' => @comments ,'will_paginate_options' => {'prev_label' => '上一页','next_label' => '下一页',:page => params[:page]||1}})
    else
      render :template => "photos"
    end
    return
  end

  def photo
    @photo = Photo.find(params[:id])
    @next_photo = Photo.find(:first,:conditions => "id>#{@photo.id}",:order => "id")
    @per_photo =  Photo.find(:first,:conditions => "id<#{@photo.id}",:order => "id")
    unless current_theme.is_sns_theme?
      render :content_type => "application/xml",:template => "/my_space/rss",:layout => 'rss'
    else
      @photos =  current_blog_user.photos.find(:all,:limit => Latest_Photos_Count,:order => 'id desc')
      render :template => 'photo'
    end
    return
  end

  def messages
    @messages = current_blog_user.messages.paginate(:page => params[:page],:per_page => Latest_Messages_Count,:order => "id desc")
    render :template => 'messages'
  end

  def friends
    @friends = current_blog_user.friends.paginate(:page => params[:page],:per_page => Latest_Friends_Count,:order => "friends.created_at desc")
    render :template => 'friends'
  end

  def votes
    @votes = current_blog_user.votes.paginate(:page => params[:page],:per_page => Latest_Votes_Count,:order => "id desc")
    render :template => 'votes'
  end

  def vote
    @vote = Vote.find(params[:id])
    @user_voters = @vote.user_votes.find(:all,:limit => 20,:order => 'id desc')
    @vote_options = VoteOption.find(:all,:conditions => "voter_id=#{@vote.id}")
    render :template => 'vote'
  end

  def groups
    @user_groups  = current_blog_user.user_groups.paginate(:page => params[:page],:per_page => Latest_Groups_Count,:order => "id desc")
    render :template => 'user_groups'
  end

  def search
    unless params[:keyword].blank?
      @categories = current_blog_user.categories
      @hot_blogs = Blog.publised_blogs.find(:all,:limit => Hot_Blog_Count,:order => "comment_count desc, view_count desc",:conditions => "user_id=#{current_blog_user.id}")
      conditions = ["user_id=#{current_blog_user.id} and (title like ? or keywords like ? or  body like ?)","%#{params[:keyword]}%","%#{params[:keyword]}%","%#{params[:keyword]}%"]
      @blogs = Blog.publised_blogs.paginate(:page => params[:page]||1,:per_page => 50, :conditions => conditions)
      render :template => 'blogs'
    else
      redirect_to :action => 'index'
    end
    return 
  end
  
  def profile
    render :template => 'profile'
  end

  protected
  
  def stat_info
    @blogs_count     = Blog.count('id', :conditions => "user_id = #{current_blog_user.id} and published = #{Blog::Published_Blogs}")
    @comments_count  = Comment.count('id', :conditions => "blog_user_id = #{current_blog_user.id}")
    blog_config = BlogConfig.find_by_user_id(current_blog_user.id)
    if blog_config
      @hits_count = blog_config.view_count
    else
      @hits_count = Blog.sum('view_count', :conditions => "user_id = #{current_blog_user.id}")
    end
    @created_at      = current_blog_user.created_at
  end

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
      tag_id = params[:tag].strip
      tag = tag_id =~ /^\d+&/  ? Tag.find(tag_id)  : Tag.find_by_name(tag_id)
      conditions << "id in (select taggable_id from taggings where tag_id=#{tag.id})"
    end
    conditions.join(' and  ')
  end
  
end
