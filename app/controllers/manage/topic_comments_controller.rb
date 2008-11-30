class Manage::TopicCommentsController < Manage::ManageController
  # GET /topic_comments
  # GET /topic_comments.xml
  def index
    @topic_comments = TopicComment.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @topic_comments }
    end
  end

  # GET /topic_comments/1
  # GET /topic_comments/1.xml
  def show
    @topic_comment = TopicComment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @topic_comment }
    end
  end

  # GET /topic_comments/new
  # GET /topic_comments/new.xml
  def new
    @topic_comment = TopicComment.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @topic_comment }
    end
  end

  # GET /topic_comments/1/edit
  def edit
    @topic_comment = TopicComment.find(params[:id])
  end

  # POST /topic_comments
  # POST /topic_comments.xml
  def create
    @topic_comment = TopicComment.new(params[:topic_comment])

    respond_to do |format|
      if @topic_comment.save
        flash[:notice] = 'TopicComment was successfully created.'
        format.html { redirect_to(@topic_comment) }
        format.xml  { render :xml => @topic_comment, :status => :created, :location => @topic_comment }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @topic_comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /topic_comments/1
  # PUT /topic_comments/1.xml
  def update
    @topic_comment = TopicComment.find(params[:id])

    respond_to do |format|
      if @topic_comment.update_attributes(params[:topic_comment])
        flash[:notice] = 'TopicComment was successfully updated.'
        format.html { redirect_to(@topic_comment) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @topic_comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /topic_comments/1
  # DELETE /topic_comments/1.xml
  def destroy
    @topic_comment = TopicComment.find(params[:id])
    @topic_comment.destroy

    respond_to do |format|
      format.html { redirect_to(topic_comments_url) }
      format.xml  { head :ok }
    end
  end
end
