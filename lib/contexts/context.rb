# Author::    Daniel Ballenger (mailto:dballenger@denetron.com)
# Copyright:: 2009,2010 Denetron LLC
# License::   
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

module ApacheConf
  module Contexts
    class InvalidContextSyntax < RuntimeError; end
    
    class Context
      class << self # Singleton methods to test if we hit a context stanza
        def start_of_context?(line)
          !!(line.strip.chomp[0] == 60 && line.strip.chomp[1] != 47) # <
        end
        
        def end_of_context?(line)
          !!(line.strip.chomp[0] == 60 && line.strip.chomp[1] == 47) # </
        end
        
        def context_name?(line)
          line.chomp.strip.split("<").last.chomp.strip.split(" ").first
          
        rescue NoMethodError
          raise InvalidContextSyntax, "Context name could not be found within brackets"
        end
        
        def context
          name.split("::").last
        end
        
        def load_context(name)
          ::ApacheConf::Contexts.const_get("#{name.chomp.strip.split('<').last.split(' ').first}")
        end
      end
      
      @sub_contexts = []
      @directives = []
      
      attr_accessor :sub_contexts, :directives
      
      def initialize
        self.sub_contexts = Array.new
        self.directives = Array.new
      end
      
      def context
        self.class.name.split("::").last
      end
      
      def to_s
        output = ""
        
        for directive in self.directives
          output += directive.to_s
        end
        
        for sub_context in self.sub_contexts
          output += sub_context.to_s
        end
        
        output
      end
    end
  end
end