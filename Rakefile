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
      SArticle.find(:all).each{|sa|
        a = Article.create(
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
        STDOUT.puts "##{article.id} [#{cn}] #{article.title} (#{article.cached_tag_list})"
        STDOUT.flush
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
        }
      }
    end
    
    desc "Migrate tags"
    task :tags => :environment do
      STDOUT.puts "Migrate tags ..."
      STag.find(:all, :conditions => "parent_id is NULL").each{|st|
        st.children.each{|stc|
          t = Tag.create(
            :id => stc.id,
            :name => stc.name,
            :top => stc.top,
            :bottom => stc.bottom,
            :category => st.name
          )
          STDOUT.puts "##{t.id} #{t.name}"
        }
      }
    end
    
    desc "Migrate links"
    task :links => :environment do
      STDOUT.puts "Migrate links ..."
      SLinkword.find(:all, :conditions => "parent_id is NULL").each{|sl|
        sl.children.each{|slc|
          l = Link.create(
            :name => slc.name,
            :url => slc.url,
            :memo => slc.memo,
            :category => sl.name
          )
          STDOUT.puts "##{l.id} #{l.name}"
        }
      }
    end 
    
    desc "Migrate users"
    task :users => :environment do
      STDOUT.puts "Migrate users ..."
      SUser.find(:all).each{|su|
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
            :user_name => su.login,
            :email => su.email,
            :hashed_password => su.salted_password,
            :salt => su.salt,
            :created_at => su.created_at,
            :theme_name => 'default'
          )
        end
        STDOUT.puts "##{u.id} #{u.user_name}"
      }
    end
    
  end
end