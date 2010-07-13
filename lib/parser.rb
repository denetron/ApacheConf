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
  class NoConfigSupplied < RuntimeError; end
  
  class Parser
    @config_line_array = []
    @index = 0
    @config_objects = []
    
    attr_accessor :config_line_array, :config_objects, :index
    
    def initialize(options = {})
      config = options[:config_array]
      self.config_line_array, self.config_objects = Array.new, Array.new
      
      for line in config
        unless line.strip[0] == 35 || line == "" # comment hash mark, or line is blank, ignore
          self.config_line_array.push(line)
        end
      end
      
      raise NoConfigSupplied, "No configuration supplied" if self.config_line_array.empty?
      
      self.index = 0
      
      while self.index < self.config_line_array.size do
        line = self.config_line_array[self.index].strip
        
        if Contexts::Context::start_of_context?(line)
          self.parse_context(true)
        elsif !Contexts::Context::end_of_context?(line) # if it isn't the start of a context stanza, it must be a directive
          self.config_objects.push(Directives::Directive::load_directive(line).parse(line))
        end
        
        self.index += 1
      end
      
      true
    end
    
    def parse_context(root = false)
      line = self.config_line_array[self.index]
      
      self.index += 1 && return if line.nil?
      self.index += 1 && return if Contexts::Context::end_of_context?(line)
      
      self.config_objects.push(Contexts::Context::load_context(line).parse(line)) if Contexts::Context::start_of_context?(line) && root
      self.config_objects.last.sub_contexts.push(Contexts::Context::load_context(line).parse(line)) if Contexts::Context::start_of_context?(line) && !root
      
      (self.config_objects.last.sub_contexts.last || self.config_objects.last).directives.push(Directives::Directive::load_directive(line).parse(line)) unless Contexts::Context::start_of_context?(line)
      
      self.index += 1
      self.parse_context
    end
    
    def find(what, name)
      objects = Array.new
      
      for obj in self.config_objects
        if obj.is_a?(name)
          objects.push(obj)
        end
      end
      
      objects
    end
    
    def generate_config
      output = ""
      
      for config_object in self.config_objects
        output += config_object.to_s
      end
      
      output
    end
    
    def self.load(configuration_file)
      self.new(:config_array => configuration_file.split("\n"))
    end
  end
end