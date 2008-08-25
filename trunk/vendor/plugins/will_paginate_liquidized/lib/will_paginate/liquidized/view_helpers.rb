module WillPaginate::Liquidized   
  module ViewHelpers
    include WillPaginate::ViewHelpers
    include ActionView::Helpers::TagHelper
    
    alias :will_paginate_without_liquid :will_paginate
    attr_reader :path
    
    def will_paginate(collection, path_info = nil)      
#      @path = deprecated_api(path_info) ||
#              @context.scopes[0]['will_paginate_options'].delete(:path)
      with_renderer 'WillPaginate::Liquidized::LinkRenderer' do 
        will_paginate_without_liquid *[collection, @context.scopes[0]['will_paginate_options']].compact
      end
    end
    
    def with_renderer(renderer)
      old_renderer, options[:renderer] = options[:renderer], renderer
      result = yield
      options[:renderer] = old_renderer
      result
    end
    
    def options
      WillPaginate::ViewHelpers.pagination_options
    end
    
    def deprecated_api(path_info)
      if path_info
        Deprecation.warn <<-DEPR
You are using a deprecated api version of the will_paginate liquid filter.
Please change your template to use: {{ collection | will_paginate }}
instead of: {{ collection | will_paginate: path_info }} 
DEPR
        path_info[:path]
      end
    end
  end

  class LinkRenderer < WillPaginate::LinkRenderer
    def page_link_or_span(page, span_class = nil, text = page.to_s)
      if page and page != current_page
#        content_tag :a, text, :href => path_for(page)
        "<a href='#{path_for(page)}'>#{text}</a>"
      else        
#        content_tag :span, text, :class => span_class
        "<span class='#{span_class}'>#{text}</span>"
      end
    end     
  
    def path_for(page)
      path = @options[:path]
      path = "#{path}/page/#{page}"
      path = path.gsub(/\/\//, '/')
      path
    end
  end  
end

module WillPaginate::Liquidized
  module Deprecation #:nodoc:
    extend ActiveSupport::Deprecation

    def self.warn(message, callstack = caller)
      message = 'WillPaginate::Liquidized: ' + message
      behavior.call(message, callstack) if behavior && !silenced?
    end

    def self.silenced?
      ActiveSupport::Deprecation.silenced?
    end
  end
end
