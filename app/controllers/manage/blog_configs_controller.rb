class Manage::BlogConfigsController < Manage::ManageController
    
  # GET /blog_configs
  # GET /blog_configs.xml
     
  def index
    @blog_config = BlogConfig.find_or_create_by_user_id(current_user.id)
    render :template  => '/manage/blog_configs/edit'
  end

  # GET /blog_configs/1
  # GET /blog_configs/1.xml
  def show
    @blog_config = BlogConfig.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @blog_config }
    end
  end

  # GET /blog_configs/new
  # GET /blog_configs/new.xml
  def new
    @blog_config = BlogConfig.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @blog_config }
    end
  end

  # GET /blog_configs/1/edit
  def edit
    @blog_config = BlogConfig.find(params[:id])
  end

  # POST /blog_configs
  # POST /blog_configs.xml
  def create
    @blog_config = BlogConfig.new(params[:blog_config])

    respond_to do |format|
      if @blog_config.save
        flash[:notice] = 'BlogConfig was successfully created.'
        format.html { redirect_to(@blog_config) }
        format.xml  { render :xml => @blog_config, :status => :created, :location => @blog_config }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @blog_config.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /blog_configs/1
  # PUT /blog_configs/1.xml
  def update
    @blog_config = BlogConfig.find(params[:id])
    respond_to do |format|
      if @blog_config.update_attributes(params[:blog_config])
        flash[:success] = '保存成功.'
        format.html { redirect_to(:action => 'index') }
        format.xml  { head :ok }
      else
        flash[:error] = '保存成功.'
        format.html { render :action => "index" }
        format.xml  { render :xml => @blog_config.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /blog_configs/1
  # DELETE /blog_configs/1.xml
  def destroy
    @blog_config = BlogConfig.find(params[:id])
    @blog_config.destroy

    respond_to do |format|
      format.html { redirect_to(blog_configs_url) }
      format.xml  { head :ok }
    end
  end
  
end
