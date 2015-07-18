module Jekyll
  module Assets
    class Logger
      def instance
        @logger ||= (
          Jekyll.logger
        )
      end

      %W(warn error info debug).each do |k|
        define_method k do |msg = nil, &block|
          if block
            instance.send(
              k, block.call
            )
          else
            instance.send(
              k, msg
            )
          end
        end
      end

      def log_level=(*a)
        raise(
          RuntimeError, "Please set log levels on Jekyll.logger"
        )
      end
    end
  end
end
