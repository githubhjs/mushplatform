class Manage::CommonController < Manage::ManageController

  def select_with_ajax
    @citys = [["请选择",""]]+City.find(:all, :conditions => ["fatherid = ?", params[:parent_id]]).collect { |item| [item.city, item.cityid] }
    render(:layout => false)
  end

  def select_with_ajax1
    @areas = Area.find(:all, :conditions => ["fatherid = ?", params[:parent_id]]).collect { |item| [item.area, item.areaid] }
    render(:layout => false)
  end
  
end
