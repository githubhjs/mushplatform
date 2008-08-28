class Admin::AssetsController < ApplicationController
  layout 'admin'
  BASE_PATH = "#{RAILS_ROOT}/public/assets"
  
  # GET /assets
  # GET /assets.xml
  def index
    @assets = Asset.paginate :page => params[:page], :order => 'created_at DESC'
    start_path = (params[:path] and params[:path].length > 0) ? "#{BASE_PATH}/#{params[:path]}" : BASE_PATH
    start_path = BASE_PATH if start_path == "#{BASE_PATH}/.."
    start_path = BASE_PATH if start_path == "#{BASE_PATH}/."
    @assets =  Dir.entries(start_path).sort.collect { |path|
      absolute_path = "#{start_path}/#{path}"
#      relative_path = params[:path] ? absolute_path[start_path.index(params[:path]), absolute_path.length-1] : path
      
      # file relative path
#      relative_path = (params[:path] and params[:path].length > 0) ? path : "#{params[:path]}/#{path}"
      relative_path = absolute_path[BASE_PATH.length+1, absolute_path.length]
        
      # file absolute path
#      absolute_path = "#{BASE_PATH}/#{relative_path}"
      
      # file parent directory path
      if relative_path.index('/..')
        parent_path = relative_path[0,relative_path.length-3]
        parent_path = parent_path.split('/')
        parent_path.delete(parent_path.last)
        parent_path = parent_path.join('/')
      elsif relative_path.index('/.')
        parent_path = relative_path[0,relative_path.length-2] 
      else
        parent_path = relative_path
      end
      
      Asset.new(:filename => File.basename(absolute_path), :name => absolute_path, :path => parent_path, :created_at => File.atime(absolute_path))
    }

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /assets/1
  # GET /assets/1.xml
  def show
    @asset = Asset.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @asset }
    end
  end

  # GET /assets/new
  # GET /assets/new.xml
  def new
    @asset = Asset.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @asset }
    end
  end

  # GET /assets/1/edit
  def edit
    @asset = Asset.find(params[:id])
  end

  # POST /assets
  # POST /assets.xml
  def create
    @asset = Asset.new(params[:asset])

    respond_to do |format|
      if @asset.save
        flash[:notice] = 'Asset was successfully created.'
        format.html { redirect_to(assets_url) }
        format.xml  { render :xml => @asset, :status => :created, :location => @asset }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @asset.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /assets/1
  # PUT /assets/1.xml
  def update
    @asset = Asset.find(params[:id])

    respond_to do |format|
      if @asset.update_attributes(params[:asset])
        flash[:notice] = 'Asset was successfully updated.'
        format.html { redirect_to(assets_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @asset.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /assets/1
  # DELETE /assets/1.xml
  def destroy
    params[:id].each{|id| 
      Asset.find(id.to_i).destroy
    } if params[:id]

    respond_to do |format|
      format.html { redirect_to(assets_url) }
      format.xml  { head :ok }
    end
  end
end
