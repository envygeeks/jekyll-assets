module Jekyll
  module Assets

    # This is a temporary class until I get back upstream and push out a
    # change that fixes Jekyll's logger's inability to accept a block and spit
    # that back out to you, for now though we work around it.

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
