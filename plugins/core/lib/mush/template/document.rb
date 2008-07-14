module Mush
  module Template
    
    class Document
      attr_accessor :nodelist
      
      # we don't need markup to open this block
      def initialize(tokens)
        parse(tokens)
      end    
      
      def parse(tokens)
        @nodelist ||= []
        @nodelist.clear

        while token = tokens.shift 

          case token
          when /^#{VariableStart}/
            @nodelist << create_variable(token)
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
      
      def create_variable(token)
        token.scan(/^#{VariableStart}(.*)#{VariableEnd}$/) do |content|
          return Variable.new(content.first)
        end
        raise SyntaxError.new("Variable '#{token}' was not properly terminated with regexp: #{VariableEnd.inspect} ")
      end
            
      def render(context)
        render_all(@nodelist, context)
      end

      def render_all(list, context)
        list.collect do |token|
          begin        
            token.respond_to?(:render) ? token.render(context) : token
          rescue Exception => e          
            context.handle_error(e)
          end
        end      
      end
      
      # There isn't a real delimter   
      def block_delimiter
        []
      end

      # Document blocks don't need to be terminated since they are not actually opened
      def assert_missing_delimitation!
      end
      
    end
    
  end
end