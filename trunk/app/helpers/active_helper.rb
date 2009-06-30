module ActiveHelper
  def generate_search_type_options(selecte_value)
    options = [['个人','0'],['学员','2'],['团队','1']]
    options_for_select(options,selecte_value)
  end
end
