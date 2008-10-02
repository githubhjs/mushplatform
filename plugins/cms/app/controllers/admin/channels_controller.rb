class Admin::ChannelsController < ApplicationController
  include Authorize
  grant_to 'admin'

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
    @parent_channel = Channel.find(params[:parent_id])
    respond_to do |format|
      format .js { render(:update) { |page| page.replace_html 'channel-form', :partial => 'new' } }
    end    
  end
  
  def edit(id = params[:node])
    @channel = id ? Channel.find(id) : Channel.new(:name => 'Blank')
    @parent_channel = @channel.parent_id ? Channel.find(@channel.parent_id) : Channel.new
    respond_to do |format|
      format.html
      format .js { render(:update) { |page| page.replace_html 'channel-form', :partial => 'edit' } }
    end    
  end
  
  def create
    @channel = Channel.new(params[:channel])
    @parent_channel = Channel.find(params[:parent_id])
    respond_to do |format|
      if @channel.save
        @parent_channel.add_child(@channel)
        flash[:notice] = 'Channel was successfully updated.'
        format .js { 
          render(:update) { |page| 
            page.replace_html 'channel-form', :partial => 'edit'
            page.call "panel.getNodeById(#{@parent_channel.id}).reload()"
          }
        }
        format.html { redirect_to(@channel) }
        format.xml  { head :ok }
      else
        format .js { render(:update) { |page| page.replace_html 'channel-form', :partial => 'edit' } }
        format.html { render :action => "edit" }
        format.xml  { render :xml => @channel.errors, :status => :unprocessable_entity }
      end
    end    
  end

  def update
    @channel = Channel.find(params[:id])
    @parent_channel = @channel.parent_id ? Channel.find(@channel.parent_id) : Channel.new()
    respond_to do |format|
      if @channel.update_attributes(params[:channel])
        flash[:notice] = 'Channel was successfully updated.'
        format.js { 
          render(:update) { |page| 
            page.replace_html 'channel-form', :partial => 'edit' 
            page.call "panel.getNodeById(#{@parent_channel.id ? @parent_channel.id : 1}).reload"
            #page.call 'root.reload'
            #page.call 'root.expand', true
          } 
        }
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
