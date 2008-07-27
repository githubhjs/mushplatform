require 'will_paginate/liquidized'
require 'will_paginate/liquidized/view_helpers'

# let WillPaginate play nice with Liquid
WillPaginate.send :include, WillPaginate::Liquidized

# register a WillPaginate Liquid filter 
Liquid::Template.register_filter(WillPaginate::Liquidized::ViewHelpers)


