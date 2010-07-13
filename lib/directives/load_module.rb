module ApacheConf
  module Directives
    class LoadModule < Directive
      @@module_path       = "libexec/apache22"
      
      @module_name        = ""
      @module_file        = ""
      
      attr_accessor :module_name, :module_file
      
      def initialize(options = {})
        @directive, @module_name, @module_file = "LoadModule", options[:module_name], options[:module_file]
      end
      
      def self.parse(line)
        directive, module_name, module_file = line.chomp.split(" ")
        
        self.new(:module_name => module_name, :module_file => module_file)
      end
      
      def to_s
        "#{self.directive} #{self.module_name} #{@@module_path}/#{self.module_file}"
      end
      alias_method :configuration_line, :to_s
    end
  end
end