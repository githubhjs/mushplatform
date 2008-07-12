require File.dirname(__FILE__) + '/mush/cms_extension'
module Cms
  class << self
    def init
      Cms::Plugin::CmsExtension.init
    end
  end
end
