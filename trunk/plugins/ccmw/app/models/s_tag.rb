class STag < ActiveRecord::Base
  establish_connection "shadowfox" 
  set_table_name "tags"
  
  has_and_belongs_to_many :articles
  has_and_belongs_to_many :blocks
  acts_as_tree :order => 'position'

  def self.find_lastest_by_parent(parent_id)
    Tag.find(:first, :conditions =>"parent_id = #{parent_id}", :order => "id desc")
  end

  def find_all_children_articles(limit = 10)
    child_ids = []
    children.each {|c| child_ids << c.id}
    Article.find_by_sql "select distinct #{Article.column_names().join(',')} from articles left join articles_tags on articles.id=articles_tags.article_id where articles.published = 1 AND articles_tags.tag_id in (#{child_ids.join(',')}) ORDER BY articles.created_at desc, articles.id desc LIMIT #{limit}"
    #Article.find(:all, :conditions => "articles.published = 1 AND articles_tags.tag_id IN (#{child_ids.join(",")})", :order => "created_at desc", :limit => limit)
  end

  def desc_articles(limit = 10)
    articles.find(:all, :order => "created_at desc", :limit => limit)
  end
end
