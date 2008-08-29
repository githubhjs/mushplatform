class MushAdminController < ApplicationController
  include Authorize
  grant_to 'admin'
  layout 'admin'

  def index
  end

end