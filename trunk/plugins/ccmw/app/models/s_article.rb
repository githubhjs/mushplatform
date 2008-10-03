class SArticle < ActiveRecord::Base
  establish_connection "shadowfox" 
  set_table_name "articles"
  
  belongs_to :user
  belongs_to :category, :class_name => 'SCategory', :foreign_key =>  'category_id'
  has_and_belongs_to_many :tags, :class_name => 'STag', :join_table => 'articles_tags',
                          :foreign_key => 'article_id', :association_foreign_key => 'tag_id'

  #after_create :create_forum_thread unless RAILS_ENV == 'test'

  def self.search( queries={} )
    conditions = "(title LIKE ? OR body LIKE ?)"
    if queries[:category]
      conditions <<  " AND category_id = ?"
      Article.find( :all, :conditions => [conditions, "%#{queries[:query]}%", "%#{queries[:query]}%", queries[:category]], :order => 'articles.id DESC', :include => [ :user, :category ] )
    else
      Article.find( :all, :conditions => [conditions, "%#{queries[:query]}%", "%#{queries[:query]}%"], :order => 'articles.id DESC', :include => [ :user, :category ] )
    end
  end

  def self.first_onfocused
    Article.find( :first, :conditions => 'onfocused = 1', :order => 'articles.id DESC', :include => [ :user, :category ] )
  end
  
  def self.all_onfocused
    Article.find( :all, :conditions => 'onfocused = 1', :order => 'articles.id DESC', :include => [ :user, :category ] )
  end

  private
  
  def create_forum_thread
    forum_user = ForumUser.find_by_username(self.user.login)
    transaction do
      # create forum thread
      thread = ForumThread.create(
        :fid => 2, # default article comments forum tid is 2
        :author => self.user.login,
        :authorid => forum_user.uid,
        :subject => self.title,
        :ifcheck => 1,
        :postdate => self.created_at.to_i,
        :lastpost => self.created_at.to_i,
        :lastposter => self.user.login
      )
      # create forum thread data
      ForumThreadText.create(
        :tid => thread.tid
      )

      # update forum data for thread and post's amount
      forum_data = ForumData.find(2);
      forum_data.topic += 1
      forum_data.article += 1
      forum_data.lastpost = "#{self.title}\t#{self.user.login}\t#{self.created_at.to_i}\tread.php?tid=#{thread.tid}&page=e"
      forum_data.save
      
      # update article's related thread id
      self.thread_id = thread.tid
      self.save
    end
  end
  
end
