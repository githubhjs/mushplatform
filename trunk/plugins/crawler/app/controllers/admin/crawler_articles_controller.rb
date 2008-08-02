class CrawlerArticlesController < ApplicationController
  # GET /crawler_articles
  # GET /crawler_articles.xml
  def index
    @crawler_articles = CrawlerArticle.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @crawler_articles }
    end
  end

  # GET /crawler_articles/1
  # GET /crawler_articles/1.xml
  def show
    @crawler_article = CrawlerArticle.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @crawler_article }
    end
  end

  # GET /crawler_articles/new
  # GET /crawler_articles/new.xml
  def new
    @crawler_article = CrawlerArticle.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @crawler_article }
    end
  end

  # GET /crawler_articles/1/edit
  def edit
    @crawler_article = CrawlerArticle.find(params[:id])
  end

  # POST /crawler_articles
  # POST /crawler_articles.xml
  def create
    @crawler_article = CrawlerArticle.new(params[:crawler_article])

    respond_to do |format|
      if @crawler_article.save
        flash[:notice] = 'CrawlerArticle was successfully created.'
        format.html { redirect_to(@crawler_article) }
        format.xml  { render :xml => @crawler_article, :status => :created, :location => @crawler_article }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @crawler_article.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /crawler_articles/1
  # PUT /crawler_articles/1.xml
  def update
    @crawler_article = CrawlerArticle.find(params[:id])

    respond_to do |format|
      if @crawler_article.update_attributes(params[:crawler_article])
        flash[:notice] = 'CrawlerArticle was successfully updated.'
        format.html { redirect_to(@crawler_article) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @crawler_article.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /crawler_articles/1
  # DELETE /crawler_articles/1.xml
  def destroy
    @crawler_article = CrawlerArticle.find(params[:id])
    @crawler_article.destroy

    respond_to do |format|
      format.html { redirect_to(crawler_articles_url) }
      format.xml  { head :ok }
    end
  end
end
