require File.dirname(__FILE__) + '/mush/extension/cms_extension'
module Cms
  class << self
    def init
      CmsExtension.init
    end
  end
end
