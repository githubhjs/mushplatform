module Admin::ChannelsHelper
  def template_options
    Template.find(:all).collect {|t| [ t.name, t.id ] }
  end
end
