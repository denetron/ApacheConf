module ApacheConf
  module Directives
    class NameVirtualHost < Directive
      @ip_address = ""
      @port       = ""
      
      attr_accessor :ip_address, :port
      
      def initialize(options = {})
        self.ip_address = options[:ip_address]
        self.port       = options[:port]
      end
      
      def self.parse(line)
        if line.index(":").nil? # We only have an ip address
          self.new(:ip_address => line.chomp.split(" ").last)
        else
          ip_address, port = line.chomp.split(" ").last.split(":")
          self.new(:ip_address => ip_address, :port => port)
        end
      end
      
      def directive_value
        if self.port.nil?
          self.ip_address
        else
          "#{self.ip_address}:#{self.port}"
        end
      end
      
      def to_s
        "#{self.directive} #{self.directive_value}"
      end
    end
  end
end
