class Manage::GiftsController < Manage::ManageController
  # GET /gifts
  # GET /gifts.xml
  Gifts_Per_Page = 17
  
  def index
    @gifts = Gift.paginate(:page => params[:page]||1,:per_page => Gifts_Per_Page)
    render :template => "/manage/gifts/index"
    return
  end

  # GET /gifts/1
  # GET /gifts/1.xml
  def show
    @gift = Gift.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @gift }
    end
  end

  # GET /gifts/new
  # GET /gifts/new.xml
  def new
    @gift = Gift.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @gift }
    end
  end

  # GET /gifts/1/edit
  def edit
    @gift = Gift.find(params[:id])
  end

  # POST /gifts
  # POST /gifts.xml
  def create
    @gift = Gift.new(params[:gift])
    respond_to do |format|
      if @gift.save
        flash[:notice] = 'Gift was successfully created.'
        format.html { redirect_to(@gift) }
        format.xml  { render :xml => @gift, :status => :created, :location => @gift }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @gift.errors, :status => :unprocessable_entity }
      end
    end
  end

  def gift_list
    @gifts = Gift.paginate(:page => params[:page]||1,:per_page => Gifts_Per_Page)
    render :update do |page|
      page.replace_html :gift_list,:partial => '/manage/gifts/gift_list',:locals => {:gifts => @gifts}
    end
  end

  # PUT /gifts/1
  # PUT /gifts/1.xml
  def update
    @gift = Gift.find(params[:id])
    respond_to do |format|
      if @gift.update_attributes(params[:gift])
        flash[:notice] = 'Gift was successfully updated.'
        format.html { redirect_to(@gift) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @gift.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /gifts/1
  # DELETE /gifts/1.xml
  def destroy
    @gift = Gift.find(params[:id])
    @gift.destroy

    respond_to do |format|
      format.html { redirect_to(gifts_url) }
      format.xml  { head :ok }
    end
  end

  def send_for
    @firends = current_user.friends
    @gifts   = Gift.paginate(:page => params[:page]||1,:per_page => Gifts_Per_Page)
    respond_to do |format|
      format.html
    end
  end
  def send_to
    friend_name = params[:friend_name].to_s
    gift_id = params[:gift_id]
    post = params[:post]
    send_mode = params[:quiet]
    
    gift_user =  GiftUser.new
    gift_user.friend_id = (User.find :first, :conditions => "user_name = '#{friend_name}'").id
    gift_user.user_id = current_user.id
    gift_user.gift_id = gift_id
    gift_user.post = post
    gift_user.send_mode = send_mode
    
    gift_user.save!
    
    @notice = "send gift success! "
    render :action => "success"
  end

  def receive
    @gift_user = GiftUser.paginate(:page => params[:page]||1,:per_page => Gifts_Per_Page, :conditions => "friend_id = #{current_user.id}")
    render :template => "/manage/gifts/receive_gift"
    return
  end

  def send_gifts
    @gift_user = GiftUser.paginate(:page => params[:page]||1,:per_page => Gifts_Per_Page, :conditions => "user_id = #{current_user.id}")
    render :template => "/manage/gifts/receive_gift"
    return
  end
end
