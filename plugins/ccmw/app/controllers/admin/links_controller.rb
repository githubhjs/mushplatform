class Admin::LinksController < ApplicationController
  include Authorize
  grant_to 'admin'
  layout 'admin'

  # GET /Links
  # GET /Links.xml
  def index
    @category = params[:category]
    conditions = {:page => params[:page], :order => 'name DESC'}
    case @category
    when nil
      @links = Link.paginate conditions
    when ''
      @links = Link.paginate conditions
#    when '未分类'
#      @links = Link.paginate_by_category '', conditions
    else
      conditions[:conditions] = "category = '#{@category}'"
      @links = Link.paginate conditions
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @links }
    end
  end

  # GET /Links/1
  # GET /Links/1.xml
  def show
    @link = Link.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @link }
    end
  end

  # GET /Links/new
  # GET /Links/new.xml
  def new
    @link = Link.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @link }
    end
  end

  # GET /Links/1/edit
  def edit
    @link = Link.find(params[:id])
  end

  # POST /Links
  # POST /Links.xml
  def create
    @link = Link.new(params[:link])

    respond_to do |format|
      if @link.save
        flash[:notice] = 'Link was successfully created.'
        format.html { redirect_to :controller => 'admin/links' }
        format.xml  { render :xml => @link, :status => :created, :location => @link }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @link.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /Links/1
  # PUT /Links/1.xml
  def update
    @link = Link.find(params[:id])

    respond_to do |format|
      if @link.update_attributes(params[:link])
        flash[:notice] = 'Link was successfully updated.'
        format.html { redirect_to :controller => 'admin/links', :action => 'index', :id => @link.id }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @link.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /Links/1
  # DELETE /Links/1.xml
  def destroy
    params[:id].each{|id| 
      link = Link.find(id.to_i)
      link.destroy
    }

    respond_to do |format|
      format.html { redirect_to(links_url) }
      format.xml  { head :ok }
    end
  end
  
end
