module Jekyll
  module AssetsPlugin
    module Logging
      protected
      def log level, message
        puts "[AssetsPlugin] #{level.to_s.upcase} #{message}"
      end
    end
  end
end
