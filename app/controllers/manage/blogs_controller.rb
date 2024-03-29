class Manage::BlogsController < Manage::ManageController
  # GET /blogs
  # GET /blogs.xml
  
  before_filter :own_blog?,:only => [:show,:edit,:update,:delete]
  
  skip_before_filter :verify_authenticity_token,:only => [:create,:update,:batch_publish]
  
  Blog_Per_Page = 10

  def own_blog?
    @blog = Blog.find(params[:id])    
    if @blog.user_id != blog_owner.id
      render :text => "此博客不存在"
      return false
    end
    return true
  end

  def index
    @blogs = Blog.publised_blogs.paginate(:page => params[:page]||1,:per_page => Blog_Per_Page,
      :conditions => generate_conditions,:include => [:category],:order => "if_top desc ,id desc")
    @categories = current_user.categories.find(:all,:limit => 10,:order => "blog_count desc")
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @blogs }
    end
  end

  # GET /blogs/1
  # GET /blogs/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @blog }
    end
  end

  # GET /blogs/new
  # GET /blogs/new.xml
  def new
    @blog = Blog.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @blog }
    end
  end

  # GET /blogs/1/edit
  def edit
#    @blog = Blog.find(params[:id])
  end

  # POST /blogs
  # POST /blogs.xml
  def create    
    @blog = Blog.new(params[:blog])
    @blog.published = params[:publish].blank?  ? Blog::Drafted_Blogs : Blog::Published_Blogs
    @blog.user_id = current_user.id
    @blog.author  = current_user.real_name
    respond_to do |format|
      if @blog.save
        flash[:notice] = 'Blog was successfully created.'
        format.html { redirect_to  params[:publish].blank? ?  "/manage/blogs/drafts " : "/manage/blogs" }
        format.xml  { render :xml => @blog, :status => :created, :location => @blog }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @blog.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /blogs/1
  # PUT /blogs/1.xml
  def update
#    @blog = Blog.find(params[:id])
    @blog.published = params[:publish].blank?  ? Blog::Drafted_Blogs : Blog::Published_Blogs
    respond_to do |format|
      if @blog.update_attributes(params[:blog])
        flash[:notice] = 'Blog was successfully updated.'
        format.html { redirect_to "/manage/blogs" }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @blog.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def delete
    if Blog.find(params[:id]).destroy
      render :update do |page|
        page["t_#{params[:id]}"].visual_effect :blind_down 
        page["t_#{params[:id]}"].remove
      end
    else
      render :update do |page|
        page["t_#{params[:id]}"].visual_effect :highlight,:startcolor => "#88ff88",:endcolor => "#114411"
      end
    end
  end
  
  def batch_publish
    ids = params[:blog_ids]
    if ids.blank? || ids.size <= 0
      flash[:error_notice] = "请选择一个进行操作"
    else
      Blog.batch_publish(ids)
      flash[:success_notice] = "发布成功"
    end
    redirect_to :action => :drafts,:category_id => params[:category_id]
    return true
  end

  def sticky
    blog = Blog.find(params[:id])
    if blog.sticky
      render :update do |page|
        page["d_a_#{params[:id]}"].replace_html  blog.is_sticky?  ? '<img alt="取消置顶" src="/images/btn_unsticky.png" >' :  '<img alt="置顶" src="/images/btn_sticky.png" >'
        page["d_a_#{params[:id]}"].visual_effect  :highlight,:startcolor => "#114411",:endcolor =>  "#88ff88"
      end
    else
      render :update do |page|
        page["d_a_#{params[:id]}"].visual_effect  :highlight,:startcolor => "#88ff88",:endcolor => "#114411"
      end 
    end
  end
  
  def search
    if params[:keywords].blank?
      redirect_to :action => :index
      return true
    end
    @blogs = Blog.publised_blogs.paginate(:page => params[:page]||1,:conditions => ["title like ? or body like ?", "%#{params[:keyword]}%","%#{params[:keyword]}%"])
    @categories = current_user.categories.find(:all,:limit => 10,:order => "blog_count desc")
    render :template => "/manage/blogs/index"
    return true
  end

  def drafts
    @blogs = Blog.draft_blogs.paginate(:page => params[:page]||1,:per_page => Blog_Per_Page,
      :conditions => generate_conditions,:include => [:category])
    @categories = current_user.categories.find(:all,:limit => 10,:order => "blog_count desc")
    render :template => "/manage/blogs/index"
    return true
  end
#  # DELETE /blogs/1
#  # DELETE /blogs/1.xml
#  def destroy
#    @blog = Blog.find(params[:id])
#    @blog.destroy
#    respond_to do |format|
#      format.html { redirect_to(blogs_url) }
#      format.xml  { head :ok }
#    end
#  end
  
  private 
  def generate_conditions
    conditions =  "user_id=#{current_user.id}"
    if !params[:category_id].blank? && params[:category_id].to_i > 0
      conditions += " and category_id=#{params[:category_id]}"
    end
    conditions
  end
end
