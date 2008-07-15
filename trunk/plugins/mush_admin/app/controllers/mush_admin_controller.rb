require 'mush_admin'
class MushAdminController < ApplicationController
  layout 'admin'
  def index
    @extension_menus = MushAdmin::MushAdminExtension.execute_extension(MushAdmin::MushAdminExtension.add_more_menu)
    render :template => 'mush_admin/index'
  end
end