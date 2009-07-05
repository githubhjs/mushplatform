class Admin::BlocksController < ApplicationController
  include Authorize
  grant_to 'admin'
  layout 'admin'

  # GET /Blocks
  # GET /Blocks.xml
  def index
    @category = params[:category]
    conditions = {:page => params[:page], :order => 'id DESC'}
    case @category
    when nil
      @blocks = Block.paginate conditions
    when ''
      @blocks = Block.paginate conditions
#    when '未分类'
#      @blocks = Block.paginate_by_category '', conditions
    else
      conditions[:conditions] = "category = '#{@category}'"
      @blocks = Block.paginate conditions
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @blocks }
    end
  end

  # GET /Blocks/1
  # GET /Blocks/1.xml
  def show
    @block = Block.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @block }
    end
  end

  # GET /Blocks/new
  # GET /Blocks/new.xml
  def new
    @block = Block.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @block }
    end
  end

  # GET /Blocks/1/edit
  def edit
    @block = Block.find(params[:id])
  end

  # POST /Blocks
  # POST /Blocks.xml
  def create
    @block = Block.new(params[:block])

    respond_to do |format|
      if @block.save
        flash[:notice] = 'Block was successfully created.'
        format.html { redirect_to :controller => 'admin/blocks' }
        format.xml  { render :xml => @block, :status => :created, :location => @block }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @block.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /Blocks/1
  # PUT /Blocks/1.xml
  def update
    @block = Block.find(params[:id])

    respond_to do |format|
      if @block.update_attributes(params[:block])
        flash[:notice] = 'Block was successfully updated.'
        format.html { redirect_to :controller => 'admin/blocks', :action => 'index', :id => @block.id }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @block.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /Blocks/1
  # DELETE /Blocks/1.xml
  def destroy    
    Block.connection.execute("delete from blocks where id in (#{params[:id].join(',')})") unless params[:id].blank?
    respond_to do |format|
      format.html { redirect_to(blocks_url) }
      format.xml  { head :ok }
    end
  end
  
end
