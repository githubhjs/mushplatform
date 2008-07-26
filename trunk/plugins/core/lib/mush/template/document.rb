require "mush/scriptlets"

module Mush

  module Template
    
    module Document
      include Mush::Scriptlets

      def parse(tokens)
        @nodelist ||= []
        @nodelist.clear

        while token = tokens.shift 

          case token
          when /^#{Liquid::TagStart}/                   
            if token =~ /^#{Liquid::TagStart}\s*(\w+)\s*(.*)?#{Liquid::TagEnd}$/

              # if we found the proper block delimitor just end parsing here and let the outer block
              # proceed                               
              if block_delimiter == $1
                end_tag
                return
              end

              # fetch the tag from registered blocks
              if tag = Liquid::Template.tags[$1]
                @nodelist << tag.new($1, $2, tokens)
              else
                # this tag is not registered with the system 
                # pass it to the current block for special handling or error reporting
                unknown_tag($1, $2, tokens)
              end              
            else
              raise SyntaxError, "Tag '#{token}' was not properly terminated with regexp: #{Liquid::TagEnd.inspect} "
            end
          when /^#{Liquid::VariableStart}/
            @nodelist << create_variable(token)
          when /^#{Liquid::ScriptletStart}/
            @nodelist << create_scriptlet(token)
          when ''
            # pass
          else
            @nodelist << token
          end
        end       

        # Make sure that its ok to end parsing in the current block. 
        # Effectively this method will throw and exception unless the current block is 
        # of type Document 
        assert_missing_delimitation!
      end  

      def create_scriptlet(token)
        token.scan(/^#{Liquid::ScriptletStart}(.*)#{Liquid::ScriptletEnd}$/) do |content|
          name = reference = content.first
          params = nil
          reference.scan(/^(.*)\((.*)\)$/ ) do |s|
            name = s[0]
            if s.length > 1
              params = s[1].gsub(/(\w+)=([^,]*)(?=\s*,?)/,':\1=>\'\2\'')
              params = eval("{#{params}}")
            end
          end
          scriptlet = @@scriptlets_registry[name]
          scriptlet.params = params if scriptlet
          return scriptlet
        end
        raise SyntaxError.new("Scriptlet '#{token}' was not properly terminated with regexp: #{Liquid::ScriptletEnd.inspect} ")
      end    

    end
    
  end
  
end
