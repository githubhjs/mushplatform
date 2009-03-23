class Manage::FriendsController <  Manage::ManageController

  helper_method :current_user
  
  PerPage = 32
  Perpage_Friend_FootStep = 30

  def index
    @friends = current_user.friends.paginate(:page => params[:page]||1,:per_page => PerPage,:order => "id desc")
    respond_to do |format|
      format.html # index.html.erb
    end
  end
    
  def search
    unless params[:keywords].blank?
      @friends = UserProfile.find(:all,:conditions => ["real_name like ?","%#{params[:keywords]}%"])
      if @friends.length == 0
        users = User.find(:all,:conditions => ["user_name like ?","%#{params[:keywords]}%"])
        for user in users
          @friends << UserProfile.new(:real_name => user.user_name, :user_id => user.id)
        end
      end
    else
      @friends=[]
    end    
  end

  def visitores
    @visitores = current_user.visitors.paginate(:page => params[:page]||1,:per_page => 20,:order => 'id desc')
  end

  def receiv_invites
    @invites = current_user.receive_invites.find(:all,:order => "id desc")
  end

  def send_invites
    @invites = current_user.send_invites.find(:all,:order => "status,id desc")
  end
  
  def invite
    return if params[:user_id].blank?
    current_user.invite(params[:user_id])
    render :update do |page|
      page.replace_html("serach_result_#{params[:user_id]}","<front class='cred'>邀请成功</front>")
    end
  end

  def cancle_invite
    Visite.delete_all("visitor_id=#{current_user.id} and user_id=#{params[:user_id]}")
  end

  def accept
    invite = current_user.receive_invites.find(:first,:conditions => "invitor_id=#{params[:user_id]}")
    invite.accept if invite
    redirect_to :action => :receiv_invites
  end
  
  def footsteps
    @friends = current_user.friends.find(:all,:limit => Latest_Friend_Count,:order => 'friends.created_at desc')
    @footsteps = if @friends.blank?
      []
    else
      Footstep.paginate(:page => params[:page]||1,:per_page => Perpage_Friend_FootStep,:order => 'created_at desc,app',
        :conditions => "user_id in (#{current_user.friends.map(&:friend_id).join(',')})")
    end
  end
  
  # POST /friends
  # POST /friends.xml
  def create
    debugger
    begin
      current_user.invite(params[:id])
    rescue
    end
    current_user.invite(params[:id])
    render :update do |page|
      page.replace_html("serach_result_#{params[:id]}","<front class='cred'>邀请成功</front>")
    end
  end

  # DELETE /friends/1
  # DELETE /friends/1.xml
  def destroy
    user = User.find(params[:id])
    begin
      current_user.friends.delete(user)
      user.friends.delete(current_user)
    rescue
    end

    respond_to do |format|
      format.html { redirect_to '/manage/friends' }
    end
  end
end
