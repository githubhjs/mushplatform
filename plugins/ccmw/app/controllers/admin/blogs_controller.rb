class Admin::BlogsController < ApplicationController
  include Authorize
  grant_to 'admin'
  layout 'admin'

  # GET /Links
  # GET /Links.xml
  def index
    condition = params[:collected].blank? ? "collected = 0" : "collected = #{params[:collected]}"
    unless params[:search_keywords].blank?
      condition = ["#{condition} and (title like ? or body like ?)","%#{params[:search_keywords]}%","%#{params[:search_keywords]}%"]
    end    
    @blogs = Blog.paginate(:conditions => condition, :order => "id desc", :page => params[:page]||1)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @blogs }
    end
  end

  # PUT /Links/1
  # PUT /Links/1.xml
  def update
    params[:id].each{|id|
      blog = Blog.find(id.to_i)
      blog.update_attribute(:collected, 1)
    }

    respond_to do |format|
      format.html { redirect_to :action => 'index' }
      format.xml  { head :ok }
    end
  end

  def abandon
    params[:id].each{|id|
      blog = Blog.find(id.to_i)
      blog.update_attribute(:collected, -1)
    }

    respond_to do |format|
      format.html { redirect_to :action => 'index' }
      format.xml  { head :ok }
    end
  end

  def delete
    params[:id].each{|id|
      blog = Blog.find(id.to_i)
      blog.destroy
    }

    respond_to do |format|
      format.html { redirect_to :action => 'index', :collected => params[:collected_code] }
      format.xml  { head :ok }
    end
  end

end
