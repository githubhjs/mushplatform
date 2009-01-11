# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def timelong(time)
    time.strftime('%Y-%m-%d %H:%M:%S') if time
  end

  def display_sitebar(sidebars)
    
  end

  def user_icon(user_id)
    profile = UserProfile.find_by_user_id(user_id)
    profile ? (profile.photo.empty? ? '/images/default_usr_icon.gif' : profile.photo) : '/images/default_usr_icon.gif'
  end

  def get_area_select_options
    Province.find(:all,:order=>'province').collect{|item|[item.province,item.provinceid]}.insert(0,["请选择..",nil])
  end
  def genreate_degree_options(select_value)
    options = [["选择类型",'0'],["专科",'1'],["本科",'2'],["研究生",'3'],["博士",'4'],['其他','5']]
    options_for_select(options, select_value.blank? ? nil : select_value.to_s)
  end

  def generate_sex_radio(select_value)
    select_value ||= Const::Sex_Unknown
    radio_boxes = []
    radio_boxes <<  (radio_button_tag('user_auth[]',Const::Sex_Man,select_value == Const::Sex_Man) + '男')
    radio_boxes <<  (radio_button_tag('user_auth[]',Const::Sex_Woman,select_value == Const::Sex_Man) + '女')
    radio_boxes <<  (radio_button_tag('user_auth[]',Const::Sex_Unknown,select_value == Const::Sex_Unknown) + '保密')
    radio_boxes.join('')
  end
end
