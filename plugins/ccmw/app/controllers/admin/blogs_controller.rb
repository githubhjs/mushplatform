class Admin::BlogsController < ApplicationController
  include Authorize
  grant_to 'admin'
  layout 'admin'

  # GET /Links
  # GET /Links.xml
  def index
    @blogs = Blog.paginate(:conditions => "collected = 0", :order => "id desc", :page => params[:page]||1)
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
      blog.update_attribute(:collected, true)
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

end
