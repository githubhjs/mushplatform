class Manage::FriendsController <  Manage::ManageController

  helper_method :current_user
  
  PerPage = 32

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

  def invite
    
  end

  def post_invite

  end
  # POST /friends
  # POST /friends.xml
  def create
    user = User.find(params[:id])
    begin
      current_user.friends << user
      user.friends << current_user
    rescue
    end
    respond_to do |format|
      format.html { redirect_to '/manage/friends' }
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
