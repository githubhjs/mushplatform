module Admin::UsersHelper
  
  def display_user_status(user)
    user.status == User::Status_Valid ? "Valid" : 'Invalid'
  end
  
  def generate_user_status_opetions(select_value)
    options = [['Valid',User::Status_Valid.to_s],['Invalid',User::Status_Invalid.to_s]]
    return options_for_select(options, select_value.blank? ? nil : select_value.to_s)
  end
  
  
  def generate_groups_checkbox(user)
    all_group = Group.all_groups || []
    user_group_ids = (user.groups || []).map(&:id)
    checked_boxes = []
    all_group.each do |g|
      checked = user_group_ids.include?(g.id)
      checked_boxes << (check_box_tag('user_groups[]',g.id,checked) + g.group_name)
    end
    checked_boxes.join(' ')
  end
  
  def display_user_roles(user)
    roles = user.authorizations
    role_names = if roles && roles.size > 0
      roles.map(&:role_name).join(',')
    else
      'No/Auth'
    end
    role_names
  end
end

