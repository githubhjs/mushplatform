class Manage::UserGroupsController < Manage::ManageController

  Group_Perpage = 10
  All_Group_Perpage = 15
  Topic_Perpage = 20
  helper_method :current_user

  # GET /user_groups
  # GET /user_groups.xml
  def index
    @user_groups = UserGroup.user_groups(current_user.id).paginate(:page => params[:page]||1,
      :per_page => All_Group_Perpage,:order => 'id desc' )
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @user_groups }
    end
  end

  def all
    @user_groups = UserGroup.paginate(:page => params[:page]||1,:per_page => Group_Perpage )
  end

  # GET /user_groups/1
  # GET /user_groups/1.xml
  def show
    @user_group = UserGroup.find(params[:id])
    @topics = Topic.paginate(:page => params[:page]||1,:per_page => Topic_Perpage,:conditions => "user_group_id=#{@user_group.id}",
      :order => "id desc")
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user_group }
    end
  end

  # GET /user_groups/new
  # GET /user_groups/new.xml
  def new
    @user_group = UserGroup.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user_group }
    end
  end

  def new_topic
    @topic = Topic.new()
    @user_group  = UserGroup.find(params[:id])
  end

  def create_topic
    @topic = Topic.new(params[:topic])
    @topic.user_id = current_user.id
    @topic.user_name = current_user.user_name
    UserGroup.add_topic_count(@topic.user_group_id) if @topic.save
    redirect_to "/manage/user_groups/#{@topic.user_group_id}"
  end

  def join
    UserGroup.join(params[:id],current_user)
    redirect_to "/manage/user_groups/#{params[:id]}"
  end
  
  def quit
    UserGroup.remove_member(params[:id].current_user)
    
    redirect_to "/manage/user_groups/#{params[:id]}"
  end

  # GET /user_groups/1/edit
  def edit
    @user_group = UserGroup.find(params[:id])
  end

  # POST /user_groups
  # POST /user_groups.xml
  def create
    @user_group = UserGroup.new(params[:user_group])
    @user_group.user_id = current_user.id
    @user_group.user_name = current_user.user_name
    respond_to do |format|
      if @user_group.save
        @user_group.upload_icon
        @user_group.save
        flash[:notice] = 'UserGroup was successfully created.'
        format.html { redirect_to(:action => :index) }
        format.xml  { render :xml => @user_group, :status => :created, :location => @user_group }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user_group.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /user_groups/1
  # PUT /user_groups/1.xml
  def update
    @user_group = UserGroup.find(params[:id])

    respond_to do |format|
      if @user_group.update_attributes(params[:user_group])
        flash[:notice] = 'UserGroup was successfully updated.'
        format.html { redirect_to(@user_group) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user_group.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /user_groups/1
  # DELETE /user_groups/1.xml
  def destroy
    @user_group = UserGroup.find(params[:id])
    @user_group.destroy

    respond_to do |format|
      format.html { redirect_to(user_groups_url) }
      format.xml  { head :ok }
    end
  end
end
