module Jekyll
  module Assets
    class Logger
      Prefix="Jekyll Assets:"
      def log
        @_log ||= Jekyll.logger
      end

      # Log Level: 1

      def warn(msg = nil, &block)
        msg = (block_given?? block.call : msg)
        log.warn(Prefix, msg)
      end

      # Log Level: 1

      def error(msg = nil, &block)
        msg = (block_given?? block.call : msg)
        log.error(Prefix, msg)
      end

      # Log Level: 2

      def info(msg = nil, &block)
        msg = (block_given?? block.call : msg)
        log.info(Prefix, msg)
      end

      # Log Level: 3

      def debug(msg = nil, &block)
        msg = (block_given?? block.call : msg)
        log.debug(Prefix, msg)
      end

      #

      def log_level=(*a)
        raise RuntimeError, "Please set log levels on Jekyll.logger"
      end
    end
  end
end
