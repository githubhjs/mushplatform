# Methods added to this helper will be available to all templates in the application.
require 'util/date_util'
require 'util/html_util'
module ApplicationHelper
  
  def timelong(time)
    time.strftime('%Y-%m-%d %H:%M:%S') if time
  end

  def display_sitebar(sidebars)
    
  end

  def user_icon(user_id = nil,size = 'small')
    if user_id
      profile = UserProfile.find_by_user_id(user_id)
      profile ? (profile.avatar.blank? ? '/images/default_usr_icon.gif' : url_for_file_column(profile, 'avatar', size)) : '/images/default_usr_icon.gif'
    else
      '/images/default_usr_icon.gif' 
    end 
  end

  def box_css
    controller_name ==  'manage'  ?  'box'  :  'box2'
  end

  def get_area_select_options
    Province.find(:all,:order=>'province').collect{|item|[item.province,item.provinceid]}.insert(0,["请选择..",nil])
  end
  def genreate_degree_options(select_value)
    options = [["选择类型",'0'],["专科",'1'],["本科",'2'],["研究生",'3'],["博士",'4'],['其他','5']]
    options_for_select(options, select_value.blank? ? nil : select_value.to_s)
  end  

  def generate_intrested_radio(attr_name,select_value)
    select_value ||= UserProfile::Intrested_Call_Center
    radio_boxes = []
    radio_boxes <<  (radio_button_tag(attr_name,UserProfile::Intrested_Call_Center,select_value == UserProfile::Intrested_Call_Center) + '呼叫中心')
    radio_boxes <<  (radio_button_tag(attr_name,UserProfile::Intrested_Client_Manage,select_value == UserProfile::Intrested_Client_Manage) + '客户管理')
    radio_boxes <<  (radio_button_tag(attr_name,UserProfile::Intrested_Data_Buy,select_value == UserProfile::Intrested_Data_Buy) + '数据营销')
    radio_boxes <<  (radio_button_tag(attr_name,UserProfile::Intrested_Server_Buy,select_value == UserProfile::Intrested_Server_Buy) + '服务外包')
    radio_boxes <<  (radio_button_tag(attr_name,UserProfile::Intrested_Other,select_value == UserProfile::Intrested_Other) + '其他')
    radio_boxes.join('')
  end
  
  def generate_sex_radio(attr_name,select_value)
    select_value ||= Const::Sex_Unknown
    radio_boxes = []
    radio_boxes <<  (radio_button_tag(attr_name,Const::Sex_Man,select_value == Const::Sex_Man) + '男')
    radio_boxes <<  (radio_button_tag(attr_name,Const::Sex_Woman,select_value == Const::Sex_Woman) + '女')
    radio_boxes <<  (radio_button_tag(attr_name,Const::Sex_Unknown,select_value == Const::Sex_Unknown) + '保密')
    radio_boxes.join('')
  end

  def generate_user_type_radio(attr_name,selected_value)
    selected_value ||= 0
    radio_boxes = []
    radio_boxes <<  (radio_button_tag(attr_name,0,selected_value == 0) + '个人')
    radio_boxes <<  (radio_button_tag(attr_name,1,selected_value == 1) + '团队')
    radio_boxes <<  (radio_button_tag(attr_name,2,selected_value == 2) + '学员')
    radio_boxes.join('')
  end

  def generate_sex_radio_for_search(select_value = Const::Sex_Unknown )
    select_value ||= Const::Sex_Unknown
    radio_boxes = []
    radio_boxes <<  (radio_button_tag('sex',Const::Sex_Man,select_value == Const::Sex_Man) + '男')
    radio_boxes <<  (radio_button_tag('sex',Const::Sex_Woman,select_value == Const::Sex_Man) + '女')
    radio_boxes <<  (radio_button_tag('sex',Const::Sex_Unknown,select_value == Const::Sex_Unknown) + '保密')
    radio_boxes.join('')
  end
  #截取页面显示内容
  def truncate_with_more (text, cutoff, id) 
    if text.length > cutoff
      result = text[0, cutoff]
      result += "<span id='text_more_link_#{id}'>&hellip;"
      result += "<a href='#' onclick='$(\"text_more_#{id}\").show(); $(\"text_more_link_#{id}\").hide(); return false;'>"
      result += "more</a></span>"
      result += "<span id='text_more_#{id}' style='display: none;'>"
      result += text[cutoff, text.length]
      result += "</span>"
    else
      result = text
    end
    result
  end

  def display_blog_admin_sex(profile = nil)
    profile ||= current_blog_user.user_profile
    if profile
      case profile.sex
      when Const::Sex_Unknown
        '保密'
      when Const::Sex_Woman
        '女'
      when Const::Sex_Man
        '男'
      end
    end
  end


end
