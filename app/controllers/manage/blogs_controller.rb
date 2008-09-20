class Manage::BlogsController < Manage::ManageController
  # GET /blogs
  # GET /blogs.xml

#  before_filter :is_space_admin?
  
  skip_before_filter :verify_authenticity_token,:only => [:create,:update,:batch_publish]
  
  Blog_Per_Page = 30
    
  def index
    @blogs = Blog.publised_blogs.paginate(:page => params[:page]||1,:per_page => Blog_Per_Page,
      :conditions => generate_conditions,:include => [:category])
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @blogs }
    end
  end

  # GET /blogs/1
  # GET /blogs/1.xml
  def show
    @blog = Blog.find(params[:id])
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
    @blog = Blog.find(params[:id])
  end

  # POST /blogs
  # POST /blogs.xml
  def create
    @blog = Blog.new(params[:blog])
    @blog.published = params[:publish].blank?  ? Blog::Drafted_Blogs : Blog::Published_Blogs
    @blog.user_id = current_user.id
    respond_to do |format|
      if @blog.save
        flash[:notice] = 'Blog was successfully created.'
        format.html { redirect_to "/manage/blogs" }
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
    @blog = Blog.find(params[:id])
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
  
  def drafts
    @blogs = Blog.draft_blogs.paginate(:page => params[:page]||1,:per_page => Blog_Per_Page,
      :conditions => generate_conditions,:include => [:category])
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
