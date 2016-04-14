# ----------------------------------------------------------------------------
# Frozen-string-literal: true
# Copyright: 2012-2015 - MIT License
# Encoding: utf-8
# ----------------------------------------------------------------------------

module Jekyll
  module Assets
    class Logger
      PREFIX = "Jekyll Assets:"

      def log
        @_log ||= Jekyll.logger
      end

      # ----------------------------------------------------------------------
      # Log Level: 1
      # ----------------------------------------------------------------------

      def warn(msg = nil)
        log.warn(PREFIX,
          block_given?? yield : msg
        )
      end

      # ----------------------------------------------------------------------
      # Log Level: 1
      # ----------------------------------------------------------------------

      def error(msg = nil)
        log.error(PREFIX,
          block_given?? yield : msg
        )
      end

      # ----------------------------------------------------------------------
      # Log Level: 2
      # ----------------------------------------------------------------------

      def info(msg = nil)
        log.info(PREFIX,
          block_given?? yield : msg
        )
      end

      # ----------------------------------------------------------------------
      # Log Level: 3
      # ----------------------------------------------------------------------

      def debug(msg = nil)
        log.debug(PREFIX,
          block_given?? yield : msg
        )
      end

      # ----------------------------------------------------------------------

      def log_level=(*)
        raise "Please set log levels on Jekyll.logger"
      end
    end
  end
end
