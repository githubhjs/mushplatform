require 'mush_admin/extension_points'

class MushAdminController < ApplicationController
  layout 'admin'
  def index
    @extension_menus = MushAdmin::ExtensionPoints.execute_extension(MushAdmin::ExtensionPoints.add_more_menu)
    render :template => 'mush_admin/index'
  end
end