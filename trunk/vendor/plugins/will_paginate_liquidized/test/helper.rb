ENV['RAILS_VERSION'] = '1.99.0'

require 'test/unit'
require 'rubygems'
require 'redgreen'

require File.dirname(__FILE__) + '/../../liquid/lib/liquid'

$LOAD_PATH.push File.dirname(__FILE__) + '/../../will_paginate/lib'
$LOAD_PATH.push File.dirname(__FILE__) + '/../../will_paginate_liquidized/lib'

require 'will_paginate/core_ext'
require 'will_paginate/view_helpers'
require 'will_paginate/liquidized'
require 'will_paginate/liquidized/view_helpers'

WillPaginate.send :include, WillPaginate::Liquidized
Liquid::Template.register_filter(WillPaginate::Liquidized::ViewHelpers)

require 'action_view/helpers/tag_helper'
include ActionView::Helpers::TagHelper

module Test
  module Unit
    module Assertions
        include Liquid
        def assert_template_result(expected, template, assigns={}, message=nil)
          assert_equal expected, Liquid::Template.parse(template).render(assigns)
        end 
    end
  end
end