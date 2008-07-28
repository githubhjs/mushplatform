module Admin::MushCrawlersHelper
  def display_crawler_satus(mush_crawler)
    mush_crawler.status == MushCrawler::Status_Runing ? 'Running' : 'Stop'
  end
end
