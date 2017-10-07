# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8


module Kernel

  # --
  # @param [String] file the file to require
  # try_require will try to require a file or skip.
  # @return [nil]
  # --
  def try_require(file)
    require file

    if block_given?
      yield
    end
  rescue LoadError
    Jekyll.logger.debug "Assets: ", "Unable to load " \
      "optional file `#{file}' - SKIPPING"
  end

  # --
  # @param [String] file the file to require
  # try_require_if_javascript will only require if there is JS.
  # @return [nil]
  # --
  def try_require_if_javascript(file)
    ["execjs", file].map(&method(:require))
    if block_given?
      yield
    end
  rescue LoadError, ExecJS::RuntimeUnavailable
    Jekyll.logger.debug "Assets: ", "JavaScript unavailable " \
      "for optional file `#{file}' - SKIPPING"
  end
end
