module ApacheConf
  module Directives
    class ServerRoot < Directive
      @root_path = ""
      
      attr_accessor :root_path
      
      def initialize(options = {})
        self.root_path = options[:root_path]
      end
      
      def self.parse(line)
        self.new(:root_path => line.chomp.split(" ").last.gsub("\"", ""))
      end
      
      def to_s
        "#{@@directive} \"#{self.root_path}\""
      end
    end
  end
end
