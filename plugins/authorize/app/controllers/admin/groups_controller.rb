require 'authorize'
class Admin::GroupsController < ApplicationController
  layout 'admin'
  
  # GET /groups
  # GET /groups.xml
  def index
    @groups = Group.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @groups }
    end
  end

  # GET /groups/1
  # GET /groups/1.xml
  def show
    @group = Group.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @group }
    end
  end

  # GET /groups/new
  # GET /groups/new.xml
  def new
    @group = Group.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @group }
    end
  end

  # GET /groups/1/edit
  def edit
    @group = Group.find(params[:id])
  end

  # POST /groups
  # POST /groups.xml
  def create
    @group = Group.new(params[:group])
    respond_to do |format|
      if @group.save
        proccess_association_roles(@group)
        flash[:notice] = 'Group was successfully created.'
        format.html { redirect_to(:action => :index) }
        format.xml  { render :xml => @group, :status => :created, :location => @group }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @group.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /groups/1
  # PUT /groups/1.xml
  def update
    @group = Group.find(params[:id])
    
    respond_to do |format|
      if @group.update_attributes(params[:group])
        proccess_association_roles(@group)
        flash[:notice] = 'Group was successfully updated.'
        format.html { redirect_to(:action => :index) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @group.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.xml
  def destroy
    @group = Group.find(params[:id])
    @group.destroy

    respond_to do |format|
      format.html { redirect_to(groups_url) }
      format.xml  { head :ok }
    end
  end
  
  private
  
  def proccess_association_roles(group)
    original_roels = group.roles||[]
    original_roel_ids = original_roels.map(&:id)
    new_role_ids = (params[:group_auth]||[]).map! { |r_id|  r_id.to_i}
    deleted_roles = original_roels.select{|g| !new_role_ids.include?(g.id)}
    Authorize::AuthManager.unauth_group(group, deleted_roles)
    added_role_ids = new_role_ids - original_roel_ids
    if added_role_ids.size > 0
      add_roles = Role.find(:all,:conditions => "id in (#{added_role_ids.join(',')})") || []
      Authorize::AuthManager.auth_group(group,add_roles)
    end
  end
end
