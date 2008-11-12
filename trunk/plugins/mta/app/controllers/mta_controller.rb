class MtaController < ApplicationController
  skip_before_filter :verify_authenticity_token
  include Authorize
#  grant_to 'admin'
  layout 'mta'

  def index
  end
  
  def dashboard
    @events = Article.find(:all, :conditions => "channel_id = 4", :order => "created_at DESC")
    @newsletters = Article.find(:all, :conditions => "channel_id = 5", :order => "created_at DESC")
    @files = Mfile.find(:all, :order => "created_at DESC")
  end

  def login
    respond_to do |format|
      format.html { redirect_to :action => :dashboard }
    end
  end
  
  def logout
    respond_to do |format|
      format.html { redirect_to '' }
    end
  end

  def events
    @articles = Article.find(:all, :conditions => "channel_id = 4", :order => "created_at DESC")

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @articles }
    end
  end

  def newsletters
    @articles = Article.find(:all, :conditions => "channel_id = 5", :order => "created_at DESC")

    respond_to do |format|
      format.html 
      format.xml  { render :xml => @articles }
    end
  end

  def files
    @files = Mfile.find(:all, :order => "created_at DESC")

    respond_to do |format|
      format.html 
      format.xml  { render :xml => @files }
    end
  end
  
  def create_file
    mfile = Mfile.new(params[:mfile])
    if mfile.save
      respond_to do |format|
        format.html { redirect_to :action => :files }
        format.xml  { render :xml => @files }
      end
    end
  end
  
  def download
    mfile = Mfile.find_by_filename(params[:file])
    send_file "#{RAILS_ROOT}/public/#{mfile.public_filename}", :type => mfile.content_type, :disposition => 'inline'
  end

end
