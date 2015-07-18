module Jekyll
  module Assets
    module Helpers
      def has_javascript?
        self.class.has_javascript(
          &Proc.new
        )
      end

      class << self
        def has_javascript?
          begin yield; rescue ExecJS::RuntimeUnavailable
            Jekyll.logger.debug(
              "No JavaScript runtime available, skipping."
            )
          end
        end

        def try_require(file)
          require file
          yield

        rescue LoadError
          return nil
        end
      end
    end
  end
end
