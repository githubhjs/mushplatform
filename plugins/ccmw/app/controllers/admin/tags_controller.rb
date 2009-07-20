class Admin::TagsController < ApplicationController
  include Authorize
  grant_to 'admin'
  layout 'admin'

  # GET /Tags
  # GET /Tags.xml
  def index
    @category = params[:category]
    conditions = {:page => params[:page], :order => 'id DESC'}
    case @category
    when nil
      @tags = Tag.paginate conditions
    when ''
      @tags = Tag.paginate conditions
#    when '未分类'
#      @tags = Tag.paginate_by_category '', conditions
    else
      conditions[:conditions] = "category = '#{@category}'"
      conditions[:per_page] = 300
      @tags = Tag.paginate conditions
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tags }
    end
  end

  # GET /Tags/1
  # GET /Tags/1.xml
  def show
    @tag = Tag.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @tag }
    end
  end

  # GET /Tags/new
  # GET /Tags/new.xml
  def new
    @tag = Tag.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @tag }
    end
  end

  # GET /Tags/1/edit
  def edit
    @tag = Tag.find(params[:id])
  end

  # POST /Tags
  # POST /Tags.xml
  def create
    @tag = Tag.new(params[:tag])

    respond_to do |format|
      if @tag.save
        flash[:notice] = 'Tag was successfully created.'
        format.html { redirect_to :controller => 'admin/tags' }
        format.xml  { render :xml => @tag, :status => :created, :location => @tag }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @tag.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /Tags/1
  # PUT /Tags/1.xml
  def update
    @tag = Tag.find(params[:id])

    respond_to do |format|
      if @tag.update_attributes(params[:tag])
        flash[:notice] = 'Tag was successfully updated.'
        format.html { redirect_to :controller => 'admin/tags', :action => 'index', :id => @tag.id }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @tag.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /Tags/1
  # DELETE /Tags/1.xml
  def destroy
    params[:id].each{|id| 
      tag = Tag.find(id.to_i)
      tag.destroy
    }

    respond_to do |format|
      format.html { redirect_to(tags_url) }
      format.xml  { head :ok }
    end
  end
  
end
