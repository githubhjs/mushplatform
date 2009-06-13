class ActiveController < ApplicationController
  before_filter :login_required, :only => [:entry]
  
  protect_from_forgery :only => [:index]
  def index 
    @blog = Blog.find :all, :limit => 10 
    @comments = Comment.find :all, :limit => 10
    @users = User.find :all, :limit => 10
    
    @focus_men = User.find :all, :limit => 10
    
  end
  
#  def read_more
#   if "comment".eql?(params[:active_type])
#     @infos = Comment.find :all
#   elsif "blog" == params[:active_type]
#     @infos = Blog.find :all
#   end
#    render :update do |page|
##      page.show params[:active_type]
#      page.replace_html params[:active_type], :partial => "more_info"
##      page.visual_effect :blind_down, params[:active_type]
##      page.call 'saveState'
#    end
#  end
  #这个方法要修改一下
  def show_news
    render :update do |page|
      page.replace_html "first_l", :partial => "news"
      page.replace_html "second_l", ""
      page.replace_html "ad2", ""
      page.replace_html "second_r", ""
      page.replace_html "second_clear", ""
    end
  end
  
  #我要参与之后进入哪里？myblog
  def entry
#    if current_user
      @blogs = Blog.find :all, :conditions => "user_id = #{current_user.id}" ,:limit => 10
      @focus_men = User.find :all, :limit => 10      
#    else
#      login_required
#    end
  end
  
end
