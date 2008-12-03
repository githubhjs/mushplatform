class Manage::TopicsController < Manage::ManageController

  TopicComment_Perpage = 30

  Topic_Perpage =  40

  helper_method :current_user

  # GET /topics
  # GET /topics.xml
  def index
    @topics = Topic.paginate(:page => params[:page]||1,:per_page => Topic_Perpage,
      :conditions => "admin_id=#{current_user.id}",:order => 'id desc' )
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @topics }
    end
  end

  # GET /topics/1
  # GET /topics/1.xml
  def show
    @topic = Topic.find(params[:id])
    @user_group = UserGroup.find(@topic.user_group_id)
    @topic_comments = TopicComment.paginate(:page => params[:page]||1,:per_page => TopicComment_Perpage,
      :conditions => "topic_id=#{@topic.id}",:order => 'id desc')
    @topic_comment = TopicComment.new
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @topic }
    end
  end


  def comments
    @topic_comment = TopicComment.new(params[:topic_comment])
    c_user = current_user
    @topic_comment.user_id = c_user.id
    @topic_comment.user_name = c_user.user_name
    Topic.add_comment(@topic_comment.topic_id) if @topic_comment.save
    redirect_to "/manage/topics/#{@topic_comment.topic_id}"
  end

  # GET /topics/new
  # GET /topics/new.xml
  def new
    @topic = Topic.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @topic }
    end
  end

  # GET /topics/1/edit
  def edit
    @topic = Topic.find(params[:id])
  end

  # POST /topics
  # POST /topics.xml
  def create
    @topic = Topic.new(params[:topic])

    respond_to do |format|
      if @topic.save
        flash[:notice] = 'Topic was successfully created.'
        format.html { redirect_to(@topic) }
        format.xml  { render :xml => @topic, :status => :created, :location => @topic }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @topic.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /topics/1
  # PUT /topics/1.xml
  def update
    @topic = Topic.find(params[:id])

    respond_to do |format|
      if @topic.update_attributes(params[:topic])
        flash[:notice] = 'Topic was successfully updated.'
        format.html { redirect_to(@topic) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @topic.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /topics/1
  # DELETE /topics/1.xml
  def destroy
    @topic = Topic.find(params[:id])
    @topic.destroy

    respond_to do |format|
      format.html { redirect_to(topics_url) }
      format.xml  { head :ok }
    end
  end
end
