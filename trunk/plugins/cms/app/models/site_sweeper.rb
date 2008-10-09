class SiteSweeper < ActionController::Caching::Sweeper
  observe Article, Channel, Template

  def after_save(record)
    self.class::sweep
  end
  
  def after_destroy(record)
    self.class::sweep
  end
  
  def self.sweep(pattern = "*")
    cache_dir = ActionController::Base.page_cache_directory
    unless cache_dir == RAILS_ROOT+"/public"
      FileUtils.rm_r(Dir.glob(cache_dir+"/#{pattern}")) rescue Errno::ENOENT
      RAILS_DEFAULT_LOGGER.info("Cache directory '#{cache_dir}' fully swept.")
    end
  end
end