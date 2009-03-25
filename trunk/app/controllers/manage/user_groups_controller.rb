class Manage::UserGroupsController < Manage::ManageController

  Group_Perpage = 10
  All_Group_Perpage = 15
  Topic_Perpage = 20
  Photo_Perpage = 20
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
    @user_groups = UserGroup.paginate(:page => params[:page]||1,:conditions => "user_id=#{current_user.id}",
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
    @user_groups = UserGroup.paginate(:page => params[:page]||1,:per_page => Group_Perpage ,:conditions => conditons,:order => "id desc")
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
    @recomment_groups = UserGroup.find(:all, :limit => 4,:order => 'topic_count desc,member_count desc')
    @group_members = GroupMember.find(:all,:limit => 8,:order => "id desc",:conditions => "group_id=#{@user_group.id}",:include => [:user])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user_group }
    end
  end
  
  def topics
    @user_group = UserGroup.find(params[:id])
    @topics = Topic.paginate(:page => params[:page]||1,:per_page => Topic_Perpage,:conditions => "user_group_id=#{params[:id]}",
      :order => "id desc")
  end
  
  def members
    @user_group = UserGroup.find(params[:id])  
    @group_members = GroupMember.paginate(:page => params[:page]||1,:per_page => Topic_Perpage,:conditions => "group_id=#{params[:id]}",
      :order => "id desc",:include => [:user])
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
  
  def new_photo
    @user_group = UserGroup.find(params[:id])
    @tags = Photo.tag_counts.map(&:name).to_json
  end

   def create_photo
    unless params[:pictures].blank?
      params[:pictures].each do |picture|
        photo = Photo.new(picture)
        photo.user_id = current_user.id
        photo.upload_image
        photo.group_id =  params[:group_id]||0
        photo.album_id =  params[:album_id]||0
        photo.save
      end
    else
      flash[:notice] = "请选择要上传的照片"
    end
    redirect_to "/manage/user_groups/#{params[:id]}/photos"
  end


   def photos
     @user_group = UserGroup.find(params[:id])
     @photos = Photo.paginate(:page => params[:page]||1,:per_page => Photo_Perpage,:conditions => "group_id=#{@user_group.id}",:order => "id desc")
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
