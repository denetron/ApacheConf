module ApacheConf
  module Directives
    class Directive
      def self.directive
        name.split("::").last
      end
      
      def directive
        self.class.name.split("::").last
      end
    end
  end
end