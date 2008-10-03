class Admin::ArticleCategoriesController < ApplicationController
  include Authorize
  grant_to 'admin'
  layout 'admin'

  # GET /ArticleCategories
  # GET /ArticleCategories.xml
  def index
    @category = params[:category]
    conditions = {:page => params[:page], :order => 'name DESC'}
    case @category
    when nil
      @article_categories = ArticleCategory.paginate conditions
    when ''
      @article_categories = ArticleCategory.paginate conditions
#    when '未分类'
#      @article_categories = ArticleCategory.paginate_by_category '', conditions
    else
      conditions[:conditions] = "category = '#{@category}'"
      @article_categories = ArticleCategory.paginate conditions
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @article_categories }
    end
  end

  # GET /ArticleCategories/1
  # GET /ArticleCategories/1.xml
  def show
    @article_category = ArticleCategory.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @article_category }
    end
  end

  # GET /ArticleCategories/new
  # GET /ArticleCategories/new.xml
  def new
    @article_category = ArticleCategory.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @article_category }
    end
  end

  # GET /ArticleCategories/1/edit
  def edit
    @article_category = ArticleCategory.find(params[:id])
  end

  # POST /ArticleCategories
  # POST /ArticleCategories.xml
  def create
    @article_category = ArticleCategory.new(params[:article_category])

    respond_to do |format|
      if @article_category.save
        flash[:notice] = 'ArticleCategory was successfully created.'
        format.html { redirect_to :controller => 'admin/article_categories' }
        format.xml  { render :xml => @article_category, :status => :created, :location => @article_category }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @article_category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /ArticleCategories/1
  # PUT /ArticleCategories/1.xml
  def update
    @article_category = ArticleCategory.find(params[:id])

    respond_to do |format|
      if @article_category.update_attributes(params[:article_category])
        flash[:notice] = 'ArticleCategory was successfully updated.'
        format.html { redirect_to :controller => 'admin/article_categories', :action => 'index', :id => @article_category.id }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @article_category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /ArticleCategories/1
  # DELETE /ArticleCategories/1.xml
  def destroy
    params[:id].each{|id| 
      article_category = ArticleCategory.find(id.to_i)
      article_category.destroy
    }

    respond_to do |format|
      format.html { redirect_to(article_categories_url) }
      format.xml  { head :ok }
    end
  end
  
end
