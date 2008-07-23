module Admin::GroupsHelper
  
  def display_group_status(group)
    group.status == Group::Status_Valid ? "Valid" : 'Invalid'
  end
  
  def generate_group_status_opetions(select_value)
    options = [['Valid',Group::Status_Valid.to_s],['Invalid',Group::Status_Invalid.to_s]]
    return options_for_select(options, select_value.blank? ? nil : select_value.to_s)
  end
  
  
  def generate_roles_checkbox(self_role_ids = [])
    check_boxes = []
    self_role_ids.map! { |r_id| r_id.to_i } if self_role_ids.size > 0
    roles = Role.all_roles
    return "" if roles.blank? || roles.size <= 0
    roles.each do |role|
      check_boxes <<  (check_box_tag('group_auth[]',role.id,self_role_ids && self_role_ids.include?(role.id))) + role.role_name
    end
    return check_boxes.join(' ')
  end
  
  def generate_inherit_group_options(group)
    options = [['No','0']]
    options += group.should_inherit_groups.map{|g|[g.group_name,g.id.to_s]}
    return options_for_select(options, group.inherit_group_id ? group.inherit_group_id.to_s : nil )
  end
end
