require 'rails_generator'
require 'rails_generator/scripts/generate'
class Admin::CrawlerSitesController < ApplicationController
  include Authorize
  grant_to 'admin'
  layout 'admin'
  
  Site_Page_Size = 50
  
  def index
    @sites = CrawlerSite.find(:all)
  end

  def show
    @site = CrawlerSite.find(params[:id])
  end

  def new
    @site = CrawlerSite.new
  end

  def edit
    @site = CrawlerSite.find(params[:id])
  end

  def stop
    site = CrawlerSite.find(params[:id])
    site.stop
    redirect_to :action => "index"
    return true
  end
  
  def run
    site = CrawlerSite.find(params[:id])
    site.run
    redirect_to :action => "index"
    return true
  end
  
  def enable
    site = CrawlerSite.find(params[:id])
    site.enable
    redirect_to :action => "index"
    return true
  end
  
  def disable
    site = CrawlerSite.find(params[:id])
    site.disable
    redirect_to :action => "index"
    return true
  end
  
  def create
    @site = CrawlerSite.new(params[:crawler_site])
    respond_to do |format|
      if @site.save
        if params[:crawler_script].blank? and !@site.crawler_existe?
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
    @site = CrawlerSite.find(params[:id])
    respond_to do |format|
      if @site.update_attributes(params[:crawler_site])
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