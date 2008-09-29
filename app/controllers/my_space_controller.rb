class MySpaceController < ApplicationController
  
  Blog_Count_PerPage =   15

  include ThememExt
  
  def index
    @blogs = Blog.publised_blogs.paginate(:page => params[:page]||1,:per_page => Blog_Count_PerPage,
      :conditions =>"user_id=#{current_space_owner.id}")
    render :template => '/articles/index'
  end

  protected
  def current_space_owner
    User.find_by_user_name(request.subdomains.first)
  end
  
end
