class Manage::FriendsController <  Manage::ManageController
  helper_method :current_user
  
  def index
    @friends = current_user.friends
    respond_to do |format|
      format.html # index.html.erb
    end
  end
    
  def search
#    if params[:query]
      @friends = UserProfile.find_all_by_real_name(params[:query])
#    end

    if @friends.length == 0
      users = User.find_all_by_user_name(params[:query])

      for user in users
        @friends << UserProfile.new(:real_name => user.user_name, :user_id => user.id)
      end
    end

    respond_to do |format|
      format.html # index.html.erb
    end
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
