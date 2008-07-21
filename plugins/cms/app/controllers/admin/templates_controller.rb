class Admin::TemplatesController < ApplicationController
  layout 'admin'

  # GET /templates
  # GET /templates.xml
  def index
    @tmplts = Template.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tmplts }
    end
  end

  # GET /templates/1
  # GET /templates/1.xml
  def show
    @tmplt = Template.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @tmplt }
    end
  end

  # GET /templates/new
  # GET /templates/new.xml
  def new
    @tmplt = Template.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @tmplt }
    end
  end

  # GET /templates/1/edit
  def edit
    @tmplt = Template.find(params[:id])
  end

  # POST /templates
  # POST /templates.xml
  def create
    @tmplt = Template.new(params[:tmplt])

    respond_to do |format|
      if @tmplt.save
        flash[:notice] = 'Template was successfully created.'
        format.html { redirect_to :controller => 'admin/templates' }
        format.xml  { render :xml => @tmplt, :status => :created, :location => @tmplt }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @tmplt.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /templates/1
  # PUT /templates/1.xml
  def update
    @tmplt = Template.find(params[:id])

    respond_to do |format|
      if @tmplt.update_attributes(params[:tmplt])
        flash[:notice] = 'Template was successfully updated.'
        format.html { redirect_to :controller => 'admin/templates', :action => 'edit', :id => @tmplt.id }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @tmplt.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /templates/1
  # DELETE /templates/1.xml
  def destroy
    @tmplt = Template.find(params[:id])
    @tmplt.destroy

    respond_to do |format|
      format.html { redirect_to(templates_url) }
      format.xml  { head :ok }
    end
  end
end
