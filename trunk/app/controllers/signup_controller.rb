class SignupController < ApplicationController
  
  layout 'site'
  
  def index
    
  end
  
  def create
    @user_profile = UserProfile.new(params[:user_profile])
    @user = User.new(paramsp[:user])
    respond_to do |format|
      if @user.save 
        @user_profile.user_id = @user.id
        @user_profile.save
        flash[:notice] = 'UserProfile was successfully created.'
        format.html { redirect_to(@user_profile) }
        format.xml  { render :xml => @user_profile, :status => :created, :location => @user_profile }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user_profile.errors, :status => :unprocessable_entity }
      end
    end
  end
  
end
