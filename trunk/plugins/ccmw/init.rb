require 'ccmw'

Article.class_eval do
  belongs_to :category, :class_name => 'ArticleCategory', :foreign_key => 'category_id'
end

Tag.class_eval do
  def to_liquid
    self.attributes.stringify_keys
  end
  
  def before_save
    if self.respond_to?(:category)
      category = '' if category.blank?
    end
  end
end