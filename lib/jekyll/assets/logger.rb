module Jekyll
  module Assets

    # This is a temporary class until I get back upstream and push out a
    # change that fixes Jekyll's logger's inability to accept a block and spit
    # that back out to you, for now though we work around it.

    class Logger
      def instance
        @logger ||= Jekyll.logger
      end

      # See: Jekyll.logger.methods

      %W(warn error info debug).each do |k|
        define_method k do |msg = nil, &block|
          instance.send(k, "Jekyll Assets:", block ? block.call : msg)
        end
      end

      # We don't let you set the logger level here because we are just
      # wrapping around Jekyll's own logger and making sure it supports the
      # most basic logging behavior, blocks as msgs being sent.

      def log_level=(*a)
        raise RuntimeError, "Please set log levels on Jekyll.logger"
      end
    end
  end
end
