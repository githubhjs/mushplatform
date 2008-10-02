class Manage::SidebarsController < Manage::ManageController
  # GET /sidebars
  # GET /sidebars.xml
  def index
    @sidebars = Sidebar.find_all_sidebar
    @sidebar_users = SidebarUser.user_sidebars(current_user.id).find(:all)
    @max_bar_index = SidebarUser.max_bar_index(current_user.id)
    @min_bar_index = SidebarUser.min_bar_index(current_user.id)
    @user = current_user
  end

  def active
    sidebar = Sidebar.find(params[:id])
    SidebarUser.create(:bar_name => sidebar.title,:user_id => current_user.id,:bar_index => ((SidebarUser.max_bar_index(current_user.id)||0) + 1),
      :description => sidebar.description,:sidebar_id => sidebar.sidebar_id)
    redirect_to :action => 'index'
  end

  def remove
    SidebarUser.delete_all("user_id=#{current_user.id} and sidebar_id ='#{params[:id]}'") 
    redirect_to :action => 'index'
  end
  
  def lower
    current_bar = SidebarUser.user_sidebars(current_user.id).find(:first,:conditions => {:sidebar_id => params[:id]})
    if current_bar.bar_index > SidebarUser.min_bar_index(current_user.id)
      lower_sidebar = SidebarUser.user_sidebars(current_user.id).find(:first,:conditions => "bar_index < #{current_bar.bar_index}")
      lower_index,current_index = lower_sidebar.bar_index,current_bar.bar_index
      lower_sidebar.update_attribute(:bar_index,current_index)
      current_bar.update_attribute(:bar_index, lower_index)
    end
    redirect_to :action => 'index'
  end

  def higher
    max_bar_index = SidebarUser.max_bar_index(current_user.id)
    current_bar = SidebarUser.user_sidebars(current_user.id).find(:first,:conditions => {:sidebar_id => params[:id]})
    if max_bar_index > current_bar.bar_index
      higher_sidebar = SidebarUser.user_sidebars(current_user.id).find(:first,:conditions => "bar_index > #{current_bar.bar_index}")
      higher_index,current_index  = higher_sidebar.bar_index,current_bar.bar_index
      higher_sidebar.update_attribute(:bar_index,current_index)
      current_bar.update_attribute(:bar_index, higher_index)
    end
    redirect_to :action => 'index'
  end
  
  # GET /sidebars/1
  # GET /sidebars/1.xml
  def show
    @sidebar = Sidebar.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @sidebar }
    end
  end

  # GET /sidebars/new
  # GET /sidebars/new.xml
  def new
    @sidebar = Sidebar.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @sidebar }
    end
  end

  # GET /sidebars/1/edit
  def edit
    sidebar = SidebarUser.find(:first,:conditions => "user_id=#{current_user.id} and sidebar_id='#{params[:id]}'")
    sidebar.update_attribute(:settings,params[:sidebar])
    render :update do |page|
      page.hide("edit_#{params[:id]}")
    end
  end

  # POST /sidebars
  # POST /sidebars.xml
  def create
    @sidebar = Sidebar.new(params[:sidebar])

    respond_to do |format|
      if @sidebar.save
        flash[:notice] = 'Sidebar was successfully created.'
        format.html { redirect_to(@sidebar) }
        format.xml  { render :xml => @sidebar, :status => :created, :location => @sidebar }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @sidebar.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /sidebars/1
  # PUT /sidebars/1.xml
  def update
    @sidebar = Sidebar.find(params[:id])
    respond_to do |format|
      if @sidebar.update_attributes(params[:sidebar])
        flash[:notice] = 'Sidebar was successfully updated.'
        format.html { redirect_to(@sidebar) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @sidebar.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /sidebars/1
  # DELETE /sidebars/1.xml
  def destroy
    @sidebar = Sidebar.find(params[:id])
    @sidebar.destroy
    respond_to do |format|
      format.html { redirect_to(sidebars_url) }
      format.xml  { head :ok }
    end
  end

end
