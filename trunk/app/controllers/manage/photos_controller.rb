class Manage::PhotosController < Manage::ManageController
  skip_before_filter :verify_authenticity_token  

  Photo_Perpage = 20

  Friend_Latest_Photos_Count = 10
  Max_Friend_Count = 10

  def index
    @photos = current_user.photos.paginate(:page => params[:page],:per_page => Photo_Perpage)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @photos }
    end
  end

  def friend_photos
    friends = current_user.friends.find(:all,:limit => Max_Friend_Count)
    @photos = if friends.blank?
      []
    else
      Photo.find(:all,:conditions => "user_id in (#{friends.map(&:friend_id).join(',')})",:order => "created_at desc")
    end
  end

  # GET /photos/1
  # GET /photos/1.xml
  def show
    @photo = Photo.find(params[:id])
    @next_photo = Photo.find(:first,:conditions => "id>#{@photo.id} and user_id=#{current_user.id}",:order => "id")
    @per_photo =  Photo.find(:first,:conditions => "id<#{@photo.id} and user_id=#{current_user.id}",:order => "id")
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @photo }
    end
  end

  # GET /photos/new
  # GET /photos/new.xml
  def new
    @photo = Photo.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @photo }
    end
  end

  # GET /photos/1/edit
  def edit
    @photo = Photo.find(params[:id])
  end

  # POST /photos
  # POST /photos.xml
  def create
    unless params[:pictures].blank?
      params[:pictures].each do |picture|
        photo = Photo.new(picture)
        photo.user_id = current_user.id
        photo.upload_image
        photo.save
      end
    else
      flash[:notice] = "请选择要上传的照片"
    end
    redirect_to :action => :index
  end

  # PUT /photos/1
  # PUT /photos/1.xml
  def update
    @photo = Photo.find(params[:id])
    respond_to do |format|
      if @photo.update_attributes(params[:photo])
        flash[:notice] = 'Photo was successfully updated.'
        format.html { redirect_to :action => :index }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @photo.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /photos/1
  # DELETE /photos/1.xml
  def destroy
    @photo = Photo.find(params[:id])
    @photo.destroy

    respond_to do |format|
      format.html { redirect_to("/manage/photos") }
      format.xml  { head :ok }
    end
  end
end