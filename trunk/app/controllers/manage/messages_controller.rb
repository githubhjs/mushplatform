class Manage::MessagesController < Manage::ManageController
  
  Messages_Per_Page = 30

  before_filter :own_message?,:only => [:show,:edit,:update,:delete]

  def own_message?
    @message = Message.find(params[:id])
    if @message.user_id != blog_owner.id
      render :text => "此博客不存在"
      return false
    end
    return true
  end

  
  # GET /messages
  # GET /messages.xml
  def index
    @messages = Message.paginate(:page => params[:page]||1,:per_page => Messages_Per_Page,
      :conditions => "user_id=#{current_user.id}", :order => "id desc")
    render :template => "/manage/messages/index"
  end

  # GET /messages/1
  # GET /messages/1.xml
  def show
#    @message = Message.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @message }
    end
  end

  # GET /messages/new
  # GET /messages/new.xml
  def new
    @message = Message.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @message }
    end
  end

  # GET /messages/1/edit
  def edit
#    @message = Message.find(params[:id])
  end

  # POST /messages
  # POST /messages.xml
  def create
    @message = Message.new(params[:message])
    @message.user_id = current_user.id
    if @message.save
      flash[:notice] = 'Message was successfully created.'
      redirect_to :action => :index
    else
      render :action => "new" 
    end
  end

  # PUT /messages/1
  # PUT /messages/1.xml
  def update
#    @message = Message.find(params[:id])
    if @message.update_attributes(params[:message])
      flash[:notice] = 'Message was successfully updated.'
      redirect_to :action => :index
    else
      render :action => "edit"
    end
  end

  def delete
    if Message.find(params[:id]).destroy
      render :update do |page|
        page["t_#{params[:id]}"].visual_effect :highlight
        page["t_#{params[:id]}"].remove
      end
    else
      render :update do |page|
        page["t_#{params[:id]}"].visual_effect :highlight
      end
    end
  end
  # DELETE /messages/1
  # DELETE /messages/1.xml
  def destroy
#    @message = Message.find(params[:id])
    @message.destroy

    respond_to do |format|
      format.html { redirect_to(messages_url) }
      format.xml  { head :ok }
    end
  end
end
