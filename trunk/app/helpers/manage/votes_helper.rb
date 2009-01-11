module Manage::VotesHelper
  
  def generate_sex_limit_options(selected_value)
    options = [['不限',Vote::Any_Sex.to_s],['仅限男性',Vote::Only_Man.to_s],['仅限女性',"#{Vote::Only_Woman}"]]
    options_for_select(options,selected_value ? selected_value.to_s : nil)
  end

  def generate_roll_limt_options(selected_value)
    options = [['所有人',Vote::Roll_Any_One.to_s],['仅限好友',Vote::Roll_Only_friend.to_s]]
    options_for_select(options,selected_value ? selected_value.to_s : nil)
  end
end
