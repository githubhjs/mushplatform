class RegardsController < ApplicationController
  # GET /regards
  # GET /regards.xml
  def index
    @regards = Regard.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @regards }
    end
  end

  # GET /regards/1
  # GET /regards/1.xml
  def show
    @regard = Regard.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @regard }
    end
  end

  # GET /regards/new
  # GET /regards/new.xml
  def new
    @regard = Regard.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @regard }
    end
  end

  # GET /regards/1/edit
  def edit
    @regard = Regard.find(params[:id])
  end

  # POST /regards
  # POST /regards.xml
  def create
    @regard = Regard.new(params[:regard])

    respond_to do |format|
      if @regard.save
        flash[:notice] = 'Regard was successfully created.'
        format.html { redirect_to(@regard) }
        format.xml  { render :xml => @regard, :status => :created, :location => @regard }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @regard.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /regards/1
  # PUT /regards/1.xml
  def update
    @regard = Regard.find(params[:id])

    respond_to do |format|
      if @regard.update_attributes(params[:regard])
        flash[:notice] = 'Regard was successfully updated.'
        format.html { redirect_to(@regard) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @regard.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /regards/1
  # DELETE /regards/1.xml
  def destroy
    @regard = Regard.find(params[:id])
    @regard.destroy

    respond_to do |format|
      format.html { redirect_to(regards_url) }
      format.xml  { head :ok }
    end
  end
end
