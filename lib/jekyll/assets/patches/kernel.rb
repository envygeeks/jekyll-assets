# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

module Kernel
  def try_require(file)
    require file
    if block_given?
      yield
    end
  rescue LoadError
    Jekyll::Assets::Logger.debug "Unable to load "
      "optional file `#{file}'"
  end

  def try_require_if_javascript(file)
    ["execjs", file].map(&method(:require))
    if block_given?
      yield
    end
  rescue LoadError, ExecJS::RuntimeUnavailable
    Jekyll::Assets::Logger.debug "JavaScript unavailable " \
      "for optional file `#{file}'"
  end
end
