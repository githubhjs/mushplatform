# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require(File.join(File.dirname(__FILE__), 'config', 'boot'))

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require 'tasks/rails'

namespace :db do
  desc "Loads a schema.rb file into the database and then loads the initial database fixtures."
  task :bootstrap do
    system "rake db:migrate:plugin[authorize]"
    system "rake db:migrate:plugin[cms]"
    system "rake db:migrate:plugin[blogengine]"
    system "rake db:migrate:plugin[ccmw]"
    system "rake db:migrate"
  end
end

namespace :data do
  namespace :migrate do
    desc "Migrate all"
    task :all => [:categories, :tags, :links, :users, :articles]
    
    desc "Migrate articles"
    task :articles => :environment do
      STDOUT.puts "Migrate articles ..."
      
      # articles
      SArticle.find(:all, :conditions => "", :offset => (SArticle.count - 10000), :limit => 10000 ).each{|sa|
        unless Article.find_by_title(sa.title)
          a = Article.create(
            :id => sa.id,
            :title => sa.title,
            :display_title => sa.display_title,
            :sub_title => sa.subtitle,
            :author => sa.author,
            :source => sa.origin,
            :excerpt => sa.excerpt,
            :redirect_url => sa.url,
            :status => sa.published,
            :top => sa.ontoped,
            :sticky => sa.onfocused,
            :user_id => sa.user_id,
            :channel_id => 1,
            :created_at => sa.created_at,
            :updated_at => sa.updated_at
          )
          Content.create(
            :id => a.id,
            :title => a.title,
            :body => sa.body,
            :page => 1,
            :article_id => a.id,
            :created_at => a.created_at,
            :updated_at => a.updated_at
          )

          # category
          article = Article.find(a.id)
          sc = sa.category
          if sc
            ac = ArticleCategory.find_by_name(sc.name)
            if ac
              cn = ac.name
              article.update_attribute('category_id', ac.id)
            end
          end

          # tags
          article = Article.find(a.id)
          sts = sa.tags.collect{|st| st.name}.join(',')
          article.tag_list = sts
          article.save

          # log
          STDOUT.puts "##{sa.id} ##{article.id} [#{cn}] #{article.title} (#{article.cached_tag_list})"
          STDOUT.flush
        else
          STDOUT.puts "##{sa.id} #{sa.title} exsited, ignore"
          STDOUT.flush
        end
      }
    end
    
    desc "Migrate categories"
    task :categories => :environment do
      STDOUT.puts "Migrate categories ..."
      SCategory.find(:all, :conditions => "parent_id is NULL").each{|sc|
        sc.children.each{|scc|
          ac = ArticleCategory.create(
            :id => scc.id,
            :name => scc.name,
            :category => sc.name
          )
          STDOUT.puts "##{ac.id} #{ac.name}"
          STDOUT.flush
        }
      }
    end
    
    desc "Migrate tags"
    task :tags => :environment do
      STDOUT.puts "Migrate tags ..."
      STag.find(:all, :conditions => "parent_id is NULL", :order => "id").each{|st|
        st.children.find(:all, :order => "id").each{|stc|
          unless Tag.find_by_name(stc.name)
            t = Tag.create(
              :id => stc.id,
              :name => stc.name,
              :top => stc.top,
              :bottom => stc.bottom,
              :category => st.name
            )
            STDOUT.puts "##{stc.id} ##{t.id} #{t.name}"
            STDOUT.flush
          end
        }
      }
    end
    
    desc "Migrate links"
    task :links => :environment do
      STDOUT.puts "Migrate links ..."
      SLinkword.find(:all, :conditions => "parent_id is NULL", :order => "id").each{|sl|
        sl.children.find(:all, :order => "id").each{|slc|
          unless Link.find_by_name(slc.name)
            l = Link.create(
              :id => slc.id,
              :name => slc.name,
              :url => slc.url,
              :memo => slc.memo,
              :category => sl.name
            )
            STDOUT.puts "##{l.id} #{l.name}"
            STDOUT.flush
          end
        }
      }
    end 
    
    desc "Migrate users"
    task :users => :environment do
      STDOUT.puts "Migrate users ..."
      SUser.find(:all, :order => "id").each{|su|
        unless MUser.find_by_user_name(su.login)
          if su.login == 'admin'
            u = MUser.find(1)
            u.update_attributes(
              :email => su.email,
              :hashed_password => su.salted_password,
              :salt => su.salt,
              :created_at => su.created_at,
              :theme_name => 'default'
            )
          else
            u = MUser.create(
              :id => su.id,
              :user_name => su.login,
              :email => su.email,
              :hashed_password => su.salted_password,
              :salt => su.salt,
              :created_at => su.created_at,
              :theme_name => 'default'
            )
            SidebarUser.create_default_sidebars(u.id) unless SidebarUser.find_by_user_id(u.id)
          end
          STDOUT.puts "##{u.id} #{u.user_name}"
          STDOUT.flush
        else
          STDOUT.puts "##{su.id} #{su.login} exist, ignore"
          STDOUT.flush
        end
      }
    end
    
    desc "Add default sidebars"
    task :sidebars => :environment do
      STDOUT.puts "Add sidebars ..."
      User.find(:all, :order => "id").each{|u|
        SidebarUser.create_default_sidebars(u.id) unless SidebarUser.find_by_user_id(u.id)
        STDOUT.puts "##{u.id} #{u.user_name}"
        STDOUT.flush
      }
    end
   
    desc "Migrate blog"
    task :blogs => :environment do
      entries = SBlogEntry.find(:all, :conditions => "", :offset => (SBlogEntry.count - 5000), :limit => 5000 )
      if entries != nil
        entries.each { |entry|
          #puts entry.subject
          unless Blog.find_by_title(entry.subject)
            user = User.find_by_user_name(entry.blog_user.username) if entry.blog_user
            if user
              if entry.text
                text = entry.text.content 
                excerpt = text.gsub(/\<(.+?)\>/, '').substr(0,200) if text.length > 200
                excerpt = text if text.length <= 200
              end
              b = Blog.create(
                :title => entry.subject,
                :author => entry.blog_user.username,
                :published => 1,
                :excerpt => excerpt,
                :body => text,
                :hits => entry.hits,
                :created_at => Time.at(entry.postdate),
                :category_id => entry.blog_category_mapping[entry.cid],
                :user_id => user.id
              )
              entry.comments.each{|comment|
                c = Comment.create(
                  :blog_id => b.id,
                  :title => comment.subject,
                  :author => comment.author,
                  :ip => comment.userip,
                  :body => comment.content,
                  :created_at => comment.postdate,
                  :user_id => 0,
                  :blog_user_id => user.id
                )
                cuser = User.find_by_user_name(comment.blog_user.username) if comment.blog_user
                if cuser
                  c.user_id = cuser.id
                  c.save
                end
              }
              STDOUT.puts "##{entry.itemid} ##{b.id} #{b.title}"
              STDOUT.flush
            end
          else
            STDOUT.puts "##{entry.id} #{entry.subject} exsited, ignore"
            STDOUT.flush
          end
        }   
      end
    end

    desc "Migrate blog author"
    task :blogs_author => :environment do
      entries = Blog.find(:all)
      if entries != nil
        entries.each { |entry|
          user = User.find(entry.user_id)
          entry.update_attribute('author', user.user_name) if user
          STDOUT.puts "##{entry.id} #{entry.author}"
          STDOUT.flush
        }   
      end
    end
    
  end
end
