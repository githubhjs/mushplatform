class Admin::ScriptletsController < ApplicationController
  layout 'admin'
  
  # GET /scriptlets
  # GET /scriptlets.xml
  def index
#    @scriptlets = Scriptlet.find(:all)
    @scriptlets = Scriptlet.paginate :page => params[:page], :order => 'created_at DESC'

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @scriptlets }
    end
  end

  # GET /scriptlets/1
  # GET /scriptlets/1.xml
  def show
    @scriptlet = Scriptlet.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @scriptlet }
    end
  end

  # GET /scriptlets/new
  # GET /scriptlets/new.xml
  def new
    @scriptlet = Scriptlet.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @scriptlet }
    end
  end

  # GET /scriptlets/1/edit
  def edit
    @scriptlet = Scriptlet.find(params[:id])
  end

  # POST /scriptlets
  # POST /scriptlets.xml
  def create
    @scriptlet = Scriptlet.new(params[:scriptlet])

    respond_to do |format|
#      if @scriptlet.save
        add_scriptlet(@scriptlet.attributes)
        flash[:notice] = 'Scriptlet was successfully created.'
        format.html { redirect_to :action => 'index' }
        format.xml  { render :xml => @scriptlet, :status => :created, :location => @scriptlet }
#      else
#        format.html { render :action => "new" }
#        format.xml  { render :xml => @scriptlet.errors, :status => :unprocessable_entity }
#      end
    end
  end

  # PUT /scriptlets/1
  # PUT /scriptlets/1.xml
  def update
    @scriptlet = Scriptlet.find(params[:id])

    respond_to do |format|
      if @scriptlet.update_attributes(params[:scriptlet])
        add_scriptlet(@scriptlet.attributes)
        flash[:notice] = 'Scriptlet was successfully updated.'
        format.html { redirect_to :action => 'index' }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @scriptlet.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /scriptlets/1
  # DELETE /scriptlets/1.xml
  def destroy
    params[:id].each{|id| 
      s = Scriptlet.find(id.to_i)
      s.destroy
      remove_scriptlet(s.name)
    } if params[:id]

    respond_to do |format|
      format.html { redirect_to(scriptlets_url) }
      format.xml  { head :ok }
    end
  end
end
