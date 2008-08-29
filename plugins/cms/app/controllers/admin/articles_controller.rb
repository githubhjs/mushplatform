class Admin::ArticlesController < ApplicationController
  include Authorize
  grant_to 'admin'
  
  # GET /articles
  # GET /articles.xml
  def index
    @channel = Channel.find(params[:channel_id])
    @articles = Article.by_channel(@channel.id)
    @articles = Article.paginate_by_channel_id @channel.id, :page => params[:page], :order => 'created_at DESC'
    
    respond_to do |format|
      format.html { render :layout => 'admin' } # index.html.erb
      format.xml  { render :xml => @articles }
      format.js { render(:update) { |page| page.replace_html 'channel-form', :partial => 'list' } }
    end
  end

  # GET /articles/1
  # GET /articles/1.xml
  def show
    @article = Article.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @article }
    end
  end

  # GET /articles/new
  # GET /articles/new.xml
  def new
    @channel = Channel.find(params[:channel_id])
    @article = Article.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @article }
      format.js { render(:update) { |page| page.replace_html 'channel-form', :partial => 'new' } }
    end
  end

  # GET /articles/1/edit
  def edit
    @article = Article.find(params[:id])
    @channel = @article.channel
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @article }
      format.js { render(:update) { |page| page.replace_html 'channel-form', :partial => 'edit' } }
    end    
  end

  # POST /articles
  # POST /articles.xml
  def create
    @article = Article.new(params[:article])

    respond_to do |format|
      if @article.save
        @article.contents.create(:body => params[:body])
        flash[:notice] = 'Article was successfully created.'
        format.html { redirect_to(@article) }
        format.xml  { render :xml => @article, :status => :created, :location => @article }
        format.js { 
          @channel = @article.channel
          @articles = Article.paginate_by_channel_id @channel.id, :page => params[:page], :order => 'created_at DESC'
          render(:update) { |page| page.replace_html 'channel-form', :partial => 'list' } 
        }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @article.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /articles/1
  # PUT /articles/1.xml
  def update
    @article = Article.find(params[:id])
    content = @article.contents[0]
    @article.contents.create(:body => params[:body]) unless content
    content.update_attribute(:body, params[:body]) if content
    

    respond_to do |format|
      if @article.update_attributes(params[:article])
        flash[:notice] = 'Article was successfully updated.'
        format.html { redirect_to(@article) }
        format.xml  { head :ok }
        format.js { 
          @channel = @article.channel
          @articles = Article.paginate_by_channel_id @channel.id, :page => params[:page], :order => 'created_at DESC'
          render(:update) { |page| page.replace_html 'channel-form', :partial => 'list' } 
        }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @article.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1
  # DELETE /articles/1.xml
  def destroy
    params[:id].each{|id| 
      Article.find(id.to_i).destroy
    } if params[:id]

    respond_to do |format|
      format.html { redirect_to(articles_url) }
      format.xml  { head :ok }
      format.js { 
        @channel = Channel.find(params[:channel_id])
        @articles = Article.paginate_by_channel_id @channel.id, :page => params[:page], :order => 'created_at DESC'
        render(:update) { |page| page.replace_html 'channel-form', :partial => 'list' } 
      }
    end
  end
end
