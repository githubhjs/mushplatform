require File.dirname(__FILE__) + '/helper'

ActiveSupport::Deprecation.silenced = true

class WillPaginateLiquidizedTest < Test::Unit::TestCase
  def setup
    @users = (1..11).to_a.paginate :page => 1, :per_page => 4
  end  
  
  def test_collection_to_liquid_should_return_drop
    assert_equal WillPaginate::Liquidized::CollectionDrop, @users.to_liquid.class
  end
  
  def test_collection_drop_should_allow_access_to_collection_methods
    [:current_page, :per_page, :total_entries, :page_count, :offset, 
     :previous_page, :next_page, :empty?, :length ].each do |method|
       assert_nothing_raised { @users.send method }
    end
    assert_nothing_raised { @users.sort_by do 1 end }
  end
  
  def test_should_allow_array_access
    assert_nothing_raised { assert_equal 1, @users[0] }
  end
  
  def test_render_deprecated_api
    template = '{{ users | will_paginate: path_info }}'    
    assigns  = {'users' => @users, 'path_info' => {:path => "/people"}}
    expected = '<div class="pagination"><span class="disabled">&laquo; Previous</span> <a href="/people">1</a> <a href="/people/page/2">2</a> <a href="/people/page/3">3</a> <a href="/people/page/2">Next &raquo;</a></div>'
    assert_template_result expected, template, assigns
  end
  
  def test_render_new_api
    template = '{{ users | will_paginate }}'
    assigns  = {'users' => @users, 'will_paginate_options' => {:path => '/people'}}
    expected = '<div class="pagination"><span class="disabled">&laquo; Previous</span> <a href="/people">1</a> <a href="/people/page/2">2</a> <a href="/people/page/3">3</a> <a href="/people/page/2">Next &raquo;</a></div>'
    assert_template_result expected, template, assigns
  end
  
  def test_should_respect_assigned_will_paginate_options
    template = '{{ users | will_paginate }}'
    assigns  = {'users' => @users, 'will_paginate_options' => {:path => '/people', :class => 'will_paginate'}}
    expected = '<div class="will_paginate"><span class="disabled">&laquo; Previous</span> <a href="/people">1</a> <a href="/people/page/2">2</a> <a href="/people/page/3">3</a> <a href="/people/page/2">Next &raquo;</a></div>'
    assert_template_result expected, template, assigns
  end
  
  def test_should_respect_assigned_will_paginate_option_param_name
    template = '{{ users | will_paginate }}'    
    assigns  = {'users' => @users, 'will_paginate_options' => {:path => '/people', :param_name => 'p'}}
    expected = '<div class="pagination"><span class="disabled">&laquo; Previous</span> <a href="/people">1</a> <a href="/people/p/2">2</a> <a href="/people/p/3">3</a> <a href="/people/p/2">Next &raquo;</a></div>'
    assert_template_result expected, template, assigns
  end
end