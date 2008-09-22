class Manage::UserProfilesController < Manage::ManageController
  
  helper :signup
  
  # GET /user_profiles
  # GET /user_profiles.xml
  def index
    @user_profile = current_user.user_profile || UserProfile.new
    render :template => "/manage/user_profiles/edit"
  end

  # GET /user_profiles/1
  # GET /user_profiles/1.xml
  def show
    @user_profile = UserProfile.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user_profile }
    end
  end

  # GET /user_profiles/new
  # GET /user_profiles/new.xml
  def new
    @user_profile = UserProfile.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user_profile }
    end
  end

  # GET /user_profiles/1/edit
  def edit
    @user_profile = UserProfile.find(params[:id])
  end

  # POST /user_profiles
  # POST /user_profiles.xml
  def create
    @user_profile = UserProfile.new(params[:user_profile])

    respond_to do |format|
      if @user_profile.save
        flash[:notice] = 'UserProfile was successfully created.'
        format.html { redirect_to(@user_profile) }
        format.xml  { render :xml => @user_profile, :status => :created, :location => @user_profile }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user_profile.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /user_profiles/1
  # PUT /user_profiles/1.xml
  def update
    @user_profile = UserProfile.find(params[:id])

    respond_to do |format|
      if @user_profile.update_attributes(params[:user_profile])
        flash[:notice] = 'UserProfile was successfully updated.'
        format.html { redirect_to(@user_profile) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user_profile.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /user_profiles/1
  # DELETE /user_profiles/1.xml
  def destroy
    @user_profile = UserProfile.find(params[:id])
    @user_profile.destroy

    respond_to do |format|
      format.html { redirect_to(user_profiles_url) }
      format.xml  { head :ok }
    end
  end
end