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
    class VirtualHost < Context
      @ip_address = ""
      @port       = ""
      
      attr_accessor :ip_address, :port
      
      def initialize(options = {})
        self.ip_address = options[:ip_address]
        self.port       = options[:port]
        super()
      end
      
      def self.parse(line)
        line = line.strip
        
        ip_address, port = line.chomp.split(" ")[1].split(":")
        self.new(:ip_address => ip_address, :port => port.gsub(">", ""))
      end
      
      def to_s
        "<#{self.context} #{self.ip_address}:#{self.port}>\n" +
        super +
        "</#{self.context}>\n"
      end
    end
  end
end