require 'rails_generator'
require 'rails_generator/scripts/generate'
class Admin::SitesController < ApplicationController
  
  layout 'admin'
  
  Site_Page_Size = 50
  
  def index
    @sites = Site.find(:all)
  end

  def show
    @site = Site.find(params[:id])
  end

  def new
    @site = Site.new
  end

  def edit
    @site = Site.find(params[:id])
  end

  def stop
    site = Site.find(params[:id])
    site.stop
    redirect_to :action => "index"
    return true
  end
  
  def run
    site = Site.find(params[:id])
    site.run
    redirect_to :action => "index"
    return true
  end
  
  def enable
    site = Site.find(params[:id])
    site.enable
    redirect_to :action => "index"
    return true
  end
  
  def disable
    @site = Site.find(params[:id])
  end
  
  def create
    @site = Site.new(params[:site])
    respond_to do |format|
      if @site.save
        if params[:crawler_script].blank?
          Rails::Generator::Scripts::Generate.new.run(["crawler",@site.site_name])
        end
        flash[:notice] = "Create site successfully"
        format.html { redirect_to :action => "index" }
        format.xml  { render :xml => @site, :status => :created, :location => @site }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @site.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @site = Site.find(params[:id])
    respond_to do |format|
      if @site.update_attributes(params[:site])
        flash[:notice] = 'Update sie successfully'
        format.html { redirect_to :action => "index"}
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @site.errors, :status => :unprocessable_entity }
      end
    end
  end
 
end