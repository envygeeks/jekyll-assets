# ----------------------------------------------------------------------------
# Frozen-string-literal: true
# Copyright: 2012 - 2016 - MIT License
# Encoding: utf-8
# ----------------------------------------------------------------------------

module Jekyll
  module Assets
    class Logger
      PREFIX = "Jekyll Assets:"

      class << self

        # --
        # @param [String] msg the message you wish to send out.
        # Deprecate a method and warn the user about it.
        # --
        def deprecate(msg, instance)
          filepath = caller[1].split(/\.rb:/).first + ".rb"
          filepath = Pathutil.new(filepath).relative_path_from(instance.in_source_dir)
          Jekyll.logger.error("", format("%s: %s", msg.red, filepath))
          yield if block_given?
        end
      end

      # --
      # @return [Jekyll:Logger]
      # The logger.
      # --
      def log
        return @log ||= Jekyll.logger
      end

      # --
      # Log Level: 1
      # --
      def warn(msg = nil)
        log.warn(PREFIX,
          block_given?? yield : msg
        )
      end

      # --
      # Log Level: 1
      # --
      def error(msg = nil)
        log.error(PREFIX,
          block_given?? yield : msg
        )
      end

      # --
      # Log Level: 2
      # --
      def info(msg = nil)
        log.info(PREFIX,
          block_given?? yield : msg
        )
      end

      # --
      # Log Level: 3
      # --
      def debug(msg = nil)
        log.debug(PREFIX,
          block_given?? yield : msg
        )
      end

      # --
      def log_level=(*)
        raise "Please set log levels on Jekyll.logger"
      end
    end
  end
end
