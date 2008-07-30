class Admin::MushCrawlersController < ApplicationController
  layout 'admin'
  # GET /mush_crawlers
  # GET /mush_crawlers.xml
  def index
    @mush_crawlers = MushCrawler.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @mush_crawlers }
    end
  end

  # GET /mush_crawlers/1
  # GET /mush_crawlers/1.xml
  def show
    @mush_crawler = MushCrawler.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @mush_crawler }
    end
  end

  # GET /mush_crawlers/new
  # GET /mush_crawlers/new.xml
  def new
    @mush_crawler = MushCrawler.new
    @crawler_template = CrawlerTemplate::Crawler_Template
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @mush_crawler }
    end
  end

  # GET /mush_crawlers/1/edit
  def edit
    @mush_crawler = MushCrawler.find(params[:id])
  end

  # POST /mush_crawlers
  # POST /mush_crawlers.xml
  def create
    @mush_crawler = MushCrawler.new(params[:mush_crawler])

    respond_to do |format|
      if @mush_crawler.save
        flash[:notice] = 'MushCrawler was successfully created.'
        format.html { redirect_to(@mush_crawler) }
        format.xml  { render :xml => @mush_crawler, :status => :created, :location => @mush_crawler }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @mush_crawler.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /mush_crawlers/1
  # PUT /mush_crawlers/1.xml
  def update
    @mush_crawler = MushCrawler.find(params[:id])

    respond_to do |format|
      if @mush_crawler.update_attributes(params[:mush_crawler])
        flash[:notice] = 'MushCrawler was successfully updated.'
        format.html { redirect_to(@mush_crawler) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @mush_crawler.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /mush_crawlers/1
  # DELETE /mush_crawlers/1.xml
  def destroy
    @mush_crawler = MushCrawler.find(params[:id])
    @mush_crawler.destroy

    respond_to do |format|
      format.html { redirect_to(mush_crawlers_url) }
      format.xml  { head :ok }
    end
  end
end
