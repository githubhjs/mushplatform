class Admin::ChannelsController < ApplicationController
  layout 'admin'
  
  def index
    channel = Channel.find_children(params[:node])
    respond_to do |format|
      format.html # render static index.html.erb
      format.json { render :json => channel }
    end
  end

  def new
    @channel = Channel.new
    respond_to do |format|
      format .js { render(:update) { |page| page.replace_html 'channel-form', :partial => 'new' } }
    end    
  end
  
  def edit(id = params[:node])
    @channel = id ? Channel.find(id) : Channel.new(:name => 'Blank')
    respond_to do |format|
      format.html { render :template => 'admin/channels/edit' }
      format .js { render(:update) { |page| page.replace_html 'channel-form', :partial => 'edit' } }
    end    
  end
  
  def update
    @channel = Channel.find(params[:id])
    respond_to do |format|
      if @channel.update_attributes(params[:channel])
        flash[:notice] = 'Channel was successfully updated.'
        format .js { render(:update) { |page| page.replace_html 'channel-form', :partial => 'edit' } }
        format.html { redirect_to(@channel) }
        format.xml  { head :ok }
      else
        format .js { render(:update) { |page| page.replace_html 'channel-form', :partial => 'edit' } }
        format.html { render :action => "edit" }
        format.xml  { render :xml => @channel.errors, :status => :unprocessable_entity }
      end
    end    
    
  end
end
