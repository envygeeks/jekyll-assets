module Jekyll
  module Assets
    class Logger
      Prefix="Jekyll Assets:"
      def log
        @_log ||= Jekyll.logger
      end

      # -----------------------------------------------------------------------
      # Log Level: 1
      # -----------------------------------------------------------------------

      def warn(msg = nil, &block)
        log.warn(Prefix, (block_given?? block.call : msg))
      end

      # -----------------------------------------------------------------------
      # Log Level: 1
      # -----------------------------------------------------------------------

      def error(msg = nil, &block)
        log.error(Prefix, (block_given?? block.call : msg))
      end

      # -----------------------------------------------------------------------
      # Log Level: 2
      # -----------------------------------------------------------------------

      def info(msg = nil, &block)
        log.info(Prefix, (block_given?? block.call : msg))
      end

      # -----------------------------------------------------------------------
      # Log Level: 3
      # -----------------------------------------------------------------------

      def debug(msg = nil, &block)
        log.debug(Prefix, (block_given?? block.call : msg))
      end

      # -----------------------------------------------------------------------

      def log_level=(*a)
        raise RuntimeError, "Please set log levels on Jekyll.logger"
      end
    end
  end
end
