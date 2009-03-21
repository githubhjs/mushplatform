class Visitor < ActiveRecord::Base

  def space_url
    "http://#{self.visitor_name}.#{Domain_Name}"
  end
end
