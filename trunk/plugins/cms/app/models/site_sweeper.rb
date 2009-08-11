include CmsHelper

class SiteSweeper < ActionController::Caching::Sweeper
  observe Article #, Channel, Template

  def after_save(record)
    self.class::sweep "#{article_permalink(record)}.html"
  end
  
  def after_destroy(record)
    self.class::sweep "#{article_permalink(record)}.html"
  end
  
  def self.sweep(pattern = "*")
    cache_dir = ActionController::Base.page_cache_directory
    unless cache_dir == RAILS_ROOT+"/public"
      FileUtils.rm_r(Dir.glob(cache_dir+"/#{pattern}")) rescue Errno::ENOENT
      RAILS_DEFAULT_LOGGER.info("#{cache_dir}/#{pattern}")
    end
  end
end