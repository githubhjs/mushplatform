class Manage::UserGroupsController < Manage::ManageController

  Group_Perpage = 10
  All_Group_Perpage = 15
  Topic_Perpage = 20
  helper_method :current_user

  before_filter :own_group,:only => [:edit,:update,:destroy]
  
  # GET /user_groups
  # GET /user_groups.xml
  
  def own_group?
    @user_group = UserGroup.find(params[:id])
    if @user_group.user_id != blog_owner.id
      render :text => "此博客不存在"
      return false
    end
    return true
  end

  def index
    @user_groups = UserGroup.user_groups(current_user).paginate(:page => params[:page]||1,
      :per_page => All_Group_Perpage,:order => 'id desc' )
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @user_groups }
    end
  end

  def all
    conditons = unless params[:keyword].blank?
      ["title like ? or description like ?","%#{params[:keyword]}%","%#{params[:keyword]}%"]
    else
      ''
    end
    @user_groups = UserGroup.paginate(:page => params[:page]||1,:per_page => Group_Perpage ,:conditions => conditons)
    render :action => :index
    return true
  end

  def search
    redirect_to :action => :all,:keyword => params[:keyword]
  end

  # GET /user_groups/1
  # GET /user_groups/1.xml
  def show
    @user_group = UserGroup.find(params[:id])
    @topics = Topic.paginate(:page => params[:page]||1,:per_page => Topic_Perpage,:conditions => "user_group_id=#{@user_group.id}",
      :order => "id desc")
    @recomment_groups = UserGroup.find(:all, :limit => 6,:order => 'topic_count desc,member_count desc')
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

  def friend_groups
    frind_ids = current_user.friends.map(&:friend_id)
    @user_groups = unless frind_ids.blank?
      UserGroup.paginate(:page => params[:page]||1,:per_page => All_Group_Perpage,:order => 'id desc',:conditions => "id in (select  group_id from group_members where user_id in (#{frind_ids.join(',')}))")
    else
      []
    end
    render :action => :index
    return true
  end

  def friend_create_groups
    frind_ids = current_user.friends.map(&:friend_id)
    @user_groups = unless frind_ids.blank?
      UserGroup.paginate(:page => params[:page]||1,:per_page => All_Group_Perpage,:order => 'id desc',:conditions => "user_id in (#{frind_ids.join(',')})")
    else
      []
    end
    render :action => :index
    return true
  end

  def join
    UserGroup.join(params[:id],current_user)
    redirect_to "/manage/user_groups/#{params[:id]}"
  end
  
  def quit
    UserGroup.remove_member(params[:id],current_user)
    
    redirect_to "/manage/user_groups/#{params[:id]}"
  end

  # GET /user_groups/1/edit
  def edit
#    @user_group = UserGroup.find(params[:id])
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
        UserGroup.join(@user_group.id,current_user)
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
#    @user_group = UserGroup.find(params[:id])

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
#    @user_group = UserGroup.find(params[:id])
    @user_group.destroy

    respond_to do |format|
      format.html { redirect_to(user_groups_url) }
      format.xml  { head :ok }
    end
  end
end
