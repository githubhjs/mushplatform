require 'authorize'
class Admin::UsersController < ApplicationController
  include Authorize
  grant_to 'admin'
  layout 'admin'
  # GET /users
  # GET /users.xml
  def index
    @users = User.paginate :page => params[:page], :order => 'created_at DESC'

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])
    respond_to do |format|
      if @user.save
        flash[:notice] = 'User was successfully created.'
        format.html { redirect_to(:action => :index) }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  def authorize_user
    user = User.find(params[:id])
    proccess_association_groups(user)
    flash[:notice] = 'User has bean successfully authorized.'
    redirect_to :action => :index
    return true
  end
  
  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])
    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = 'User was successfully updated.'
        format.html { redirect_to(:action => :index) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def search
    @users = User.find_by_user_name(params[:name])

    respond_to do |format|
      format.html { render :template => "index" }
      format.xml  { render :xml => @users }
    end
  end
 
  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end
  private
  def proccess_association_groups(user)
    user_group_ids = (user.groups || []).map(&:id)
    form_group_ids = (params[:user_groups]||[]).map{|g_id|g_id.to_i}
    deleted_group_ids = user_group_ids - form_group_ids
    if deleted_group_ids && deleted_group_ids.size > 0
      Authorize::AuthManager.unauth_user(user, deleted_group_ids)
    end
    add_group_ids = form_group_ids - user_group_ids
    if add_group_ids && add_group_ids.size > 0
      Authorize::AuthManager.auth_user(user, add_group_ids)
    end
  end
end
