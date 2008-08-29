require 'shared-mime-info'
require 'zip/zipfilesystem'

class Admin::AssetsController < ApplicationController
  layout 'admin'
  BASE_PATH = "#{RAILS_ROOT}/public/assets"
  
  # GET /assets
  # GET /assets.xml
  def index
    @path = params[:path]
    start_path = (@path and @path.length > 0) ? "#{BASE_PATH}/#{@path}" : BASE_PATH
    start_path = BASE_PATH if start_path == "#{BASE_PATH}/.."
    start_path = BASE_PATH if start_path == "#{BASE_PATH}/."
    @assets =  Dir.entries(start_path).sort.collect { |path|
      # file absolute path
      absolute_path = "#{start_path}/#{path}"
      
      # file relative path
      relative_path = absolute_path[BASE_PATH.length+1, absolute_path.length]
        
      # file parent directory path
      if relative_path.index('/..')
        parent_path = relative_path[0,relative_path.length-3]
        parent_path = parent_path.split('/')
        parent_path.delete(parent_path.last)
        parent_path = parent_path.join('/')
        relative_path = parent_path
      elsif relative_path.index('/.')
        parent_path = relative_path[0,relative_path.length-2]
        relative_path = parent_path
      else
        parent_path = relative_path
      end
      
      Asset.new(:filename => File.basename(absolute_path), 
                :path => relative_path,
                :full_path => absolute_path, 
                :parent_path => parent_path,
                :content_type => MIME.check(absolute_path).to_s,
                :created_at => File.atime(absolute_path))
    }

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /assets/1
  # GET /assets/1.xml
  def show
    file = params[:file]
    @asset = Asset.new(:filename =>file)
    @body = IO.read("#{BASE_PATH}/#{file}")

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @asset }
    end
  end

  # GET /assets/new
  # GET /assets/new.xml
  def new
    @path = params[:path]

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @asset }
    end
  end

  # GET /assets/1/edit
  def edit
    path = params[:path]
    full_path = "#{BASE_PATH}/#{path}"
    @asset = Asset.new(
                :filename => File.basename(path), 
                :path => path,
                :full_path => full_path, 
                :parent_path => path.gsub(/\/([^\/]*)\.([^\/]*)/, ''),
                :content_type => MIME.check(full_path).to_s,
                :created_at => File.atime(full_path))
    @body = IO.read(@asset.full_path)
  end

  # POST /assets
  # POST /assets.xml
  def create
    @path = params[:path]
    dir = params[:dir]
    file = params[:file]
    
    full_dir = (dir and dir.length > 0) ? "#{BASE_PATH}/#{@path}/#{dir}" : "#{BASE_PATH}/#{@path}"
    FileUtils.mkdir_p(full_dir)
    
    if file.class != String
      filename = file.original_filename
      full_path = "#{full_dir}/#{filename}"
      File.open(full_path, "w") { |file| file.write(params[:file].read) }
      unzip_file(full_path, full_dir) if MIME.check(full_path).subtype == 'zip'
      File.delete full_path
    end

    respond_to do |format|
      flash[:notice] = 'Asset was successfully created.'
      format.html { redirect_to(:action => 'index', :path => @path ) }
      format.xml  { render :xml => @asset, :status => :created, :location => @asset }
    end
  end

  # PUT /assets/1
  # PUT /assets/1.xml
  def update
    path = params[:path]
    full_path = "#{BASE_PATH}/#{path}"
    @asset = Asset.new(
                :filename => File.basename(path), 
                :path => path,
                :full_path => full_path, 
                :parent_path => path.gsub(/\/([^\/]*)\.([^\/]*)/, ''),
                :content_type => MIME.check(full_path).to_s,
                :created_at => File.atime("#{BASE_PATH}/#{path}"))    
    File.open(full_path,"w"){|file| file.puts params[:body]}
    @body = IO.read(full_path)
    
    respond_to do |format|
      flash[:notice] = 'Asset was successfully updated.'
      format.html { render :template => 'admin/assets/edit' }
      format.xml  { head :ok }
    end
  end

  # DELETE /assets/1
  # DELETE /assets/1.xml
  def destroy
    params[:path].each{|path|
      full_path = "#{BASE_PATH}/#{path[0]}"
      begin
        if File.directory?(full_path)
          #Dir.rmdir full_path
          FileUtils.rm_rf(full_path)
        else
          File.delete full_path
        end
      rescue
      end
    } if params[:path]

    respond_to do |format|
      format.html { redirect_to(assets_url) }
      format.xml  { head :ok }
    end
  end
  
  def unzip_file(source, target)
    Zip::ZipFile.open(source) do |zipfile|
     zipfile.each { |entry|
       full_path = File.join(target, entry.name)
       FileUtils.mkdir_p(File.dirname(full_path))
       zipfile.extract(entry, full_path) unless File.exist?(full_path)
     }
    end
  end
  
end
