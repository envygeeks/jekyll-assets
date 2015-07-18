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
          require "execjs"
          if block_given?
            yield
          end

        rescue LoadError, ExecJS::RuntimeUnavailable
          Jekyll.logger.debug(
            "No JavaScript runtime available, skipping."
          )
        end

        def try_require(file)
          require file
          if block_given?
            yield
          end

        rescue LoadError
          return nil
        end

        def try_require_if_javascript?(file)
          has_javascript? do
            try_require file do
              if block_given?
                yield
              end
            end
          end
        end
      end
    end
  end
end
