module ComboboxHelper
  VERSION = '0.1.0'
  module FormHelper
    # values should be a string array
    def combobox_field(object_name, field, values, options = {})
      if values
        values = values.collect{|item| "\'#{item}\'"}.join(',')
      end
      output = ""
      output << text_field(object_name, field, :autocomplete => "off")
      output << "<div class=\"#{object_name}_#{field}_auto_complete\" id=\"#{object_name}_#{field}_list\" style=\"display:none\"></div>\r"
      output << "<script type=\"text/javascript\">
        #{object_name}#{field}AutoCompleter = new Autocompleter.Local('#{object_name}_#{field}', '#{object_name}_#{field}_list', [#{values}], {choices:100,autoSelect:false});
        Event.observe($('#{object_name}_#{field}'), \"focus\", #{object_name}#{field}AutoCompleter.activate.bind(#{object_name}#{field}AutoCompleter));
        Event.observe($('#{object_name}_#{field}'), \"click\", #{object_name}#{field}AutoCompleter.activate.bind(#{object_name}#{field}AutoCompleter));
        </script>\r"
      output << "<style>
        div.#{object_name}_#{field}_auto_complete {
          background:#FFFFFF none repeat scroll 0 0;
          display:inline;
          width:98%;
          z-index:98;
        }
        div.#{object_name}_#{field}_auto_complete ul {
          border:1px solid #C6D9E9;
          list-style-type:none;
          margin:0;
          padding:0 2px 0 2px;
          width:98%;
          list-style-image:none;
          list-style-position:outside;
        }          
        div.#{object_name}_#{field}_auto_complete ul li {
          color:#999999;
          list-style-type:none;
          margin:0;
          font-size:1.1em;
          padding:3px 0;
        }
        div.#{object_name}_#{field}_auto_complete ul li.selected {
          background-color:#FFFFBB;
        }
      </style>\r"
    end
  end
end