module WillPaginate::Liquidized   
  module ViewHelpers
    include WillPaginate::ViewHelpers
    alias :will_paginate_without_liquid :will_paginate
    attr_reader :path
    
    def will_paginate(collection, path_info = nil)      
      @path = deprecated_api(path_info) ||
              @context.scopes[0]['will_paginate_options'].delete(:path)
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
      unless page
        content_tag :span, text, :class => span_class
      else        
        content_tag :a, text, :href => path_for(page)
      end
    end     
  
    def path_for(page)      
      path = []
      path << @template.path unless @template.path.blank? 
      path << @options[:param_name] << page unless page == 1
      ('/' + path.join('/')).gsub('//', '/')
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