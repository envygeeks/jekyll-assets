module Kernel
  def has_javascript?
    require "execjs"
    if block_given?
      yield
    end
  rescue LoadError, ExecJS::RuntimeUnavailable
    Jekyll.logger.debug("ExecJS or JS Runtime not available." \
      " Skipping loading of library.")
  end

  #

  def try_require(file)
    require file
    if block_given?
      yield
    end
  rescue LoadError
    return nil
  end

  #

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
