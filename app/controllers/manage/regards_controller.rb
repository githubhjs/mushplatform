class Manage::RegardsController < Manage::ManageController

  Regard_Per_Page = 20
  
  # GET /regards
  # GET /regards.xml
  def index
    @regards = Regard.find(:all)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @regards }
    end
  end

  # GET /regards/1
  # GET /regards/1.xml
  def show
    @regard = Regard.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @regard }
    end
  end

  # GET /regards/new
  # GET /regards/new.xml
  def new
    @regard = Regard.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @regard }
    end
  end

  # GET /regards/1/edit
  def edit
    @regard = Regard.find(params[:id])
  end

  # POST /regards
  # POST /regards.xml
  def create
    @regard = Regard.new(params[:regard])

    respond_to do |format|
      if @regard.save
        flash[:notice] = 'Regard was successfully created.'
        format.html { redirect_to(@regard) }
        format.xml  { render :xml => @regard, :status => :created, :location => @regard }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @regard.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /regards/1
  # PUT /regards/1.xml
  def update
    @regard = Regard.find(params[:id])
    respond_to do |format|
      if @regard.update_attributes(params[:regard])
        flash[:notice] = 'Regard was successfully updated.'
        format.html { redirect_to(@regard) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @regard.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /regards/1
  # DELETE /regards/1.xml
  def destroy
    @regard = Regard.find(params[:id])
    @regard.destroy
    respond_to do |format|
      format.html { redirect_to(regards_url) }
      format.xml  { head :ok }
    end
  end

  def send_for
    @firends = current_user.friends
    @regards = Regard.paginate(:page => params[:page]||1,:per_page => 20)
    @regard_user = RegardUser.new
    respond_to do |format|
      format.html
    end
  end
  
  def send_to
    @regard_user =  RegardUser.new(params[:regard_user])
    @regard_user.user_id = current_user.id
    unless (friend_name  = params[:regard_user][:friend_name]).blank?
      debugger
      usr = User.find_by_user_name(friend_name)
      @regard_user.friend_id = usr.id if usr
    end
    if @regard_user.save
      @notice = "礼品赠送成功! "
      render :action => "success"
    else
      @firends = current_user.friends
      @regards   = Regard.paginate(:page => params[:page]||1,:per_page => Regard_Per_Page)
      flash[:notice] = @regard_user.errors.full_messages.join(';')
      render :action => :send_for
    end
  end
  
  def receive
    @user_reagrds = RegardUser.paginate(:page => params[:page]||1,:per_page => Regard_Per_Page, :conditions => "friend_id = #{current_user.id}")
    render :template => "/manage/regards/receive_regard"
    return
  end

  def send_regards
    @user_reagrds = RegardUser.paginate(:page => params[:page]||1,:per_page => Regard_Per_Page, :conditions => "user_id = #{current_user.id}")
    render :template => "/manage/regards/receive_regard"
    return
  end
end
