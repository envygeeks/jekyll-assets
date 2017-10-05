# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

module Jekyll
  module Assets
    module Patches
      module Kernel

        # --
        # @param [String] file the file to require
        # try_require will try to require a file and if it's
        # unable to, it will just let you carry on.  This is very
        # useful when you want to check for a dependency.
        # @return [nil]
        # --
        def try_require(file)
          require file

          if block_given?
            yield
          end
        rescue LoadError
          return nil
        end

        # --
        # @param [String] file the file to require
        # try_require_if_javascript will only require a file
        # if we can find a valid JavaScript engine, that way we don't
        # try and load something like less if we don't have the
        # capability to run it, Jekyll Assets has optional
        # engines that you can run.
        # @return [nil]
        # --
        def try_require_if_javascript(file)
          ["execjs", file].map(&method(:require))

          if block_given?
            yield
          end
        rescue LoadError, ExecJS::RuntimeUnavailable
          Jekyll.logger.debug("ExecJS, JS Runtime or `#{file}' not available." \
            " Skipping the loading of libraries.")
          return
        end
      end
    end
  end
end

module Kernel
  prepend Jekyll::Assets::Patches::Kernel
end
