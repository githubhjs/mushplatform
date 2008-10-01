class Manage::SidebarsController < Manage::ManageController
  # GET /sidebars
  # GET /sidebars.xml
  def index
    @sidebars = Sidebar.find_all_sidebar
    @sidebar_users = SidebarUser.user_sidebars(current_user.id).find(:all)
    @max_bar_index = SidebarUser.max_bar_index(current_user.id)
    @min_bar_index = SidebarUser.min_bar_index(current_user.id)
  end

  def active
    sidebar = Sidebar.find(params[:id])
    SidebarUser.create(:sidebar_id => sidebar.title,:user_id => current_user.id,:bar_index => SidebarUser.user_sidebars.count + 1,
      :description => sidebar.description,:sidebar_id => sidebar.sidebar_id)
    render :action => 'index'
  end

  def remove
    SidebarUser.delete_all("user_id=#{current_user.id} and sidebar_id ='#{params[:id]}'") 
    render :action => 'index'
  end
  
  def down
    current_bar = SidebarUser.user_sidebars(current_user.id).find(:first,:conditions => {:sidebar_id => params[:id]})
    if current_bar.bar_index > SidebarUser.SidebarUser.min_bar_index(current_user.id)
      SidebarUser.update_all("bar_index=#{current_bar.bar_index + 1}", "user_id=#{current_user.id} and bar_index=#{current_bar.bar_index-1}")
      current_bar.update_attribute(:bar_index, current_bar.bar_index-1)
    end
    render :action => 'index'
  end

  def up
    max_bar_index = max_bar_index(current_user.id)
    current_bar = SidebarUser.user_sidebars(current_user.id).find(:first,:conditions => {:sidebar_id => params[:id]})
    if max_bar_index > current_bar.index
      SidebarUser.update_all("bar_index=#{current_bar.bar_index-1}", "user_id=#{current_user.id} and bar_index=#{current_bar.bar_index+1}")
      current_bar.update_attribute(:bar_index, current_bar.bar_index+1)
    end
    render :action => 'index'
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
    @sidebar = Sidebar.find(params[:id])
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
