# Frozen-string-literal: true
# Copyright: 2012-2015 - MIT License
# Encoding: utf-8

require "tilt"
require "sprockets"
require "jekyll"

module Jekyll
  module Assets
    require_relative "assets/version"
    require_relative "assets/patches"
    require_relative "assets/cached"
    require_relative "assets/config"
    require_relative "assets/env"
    require_relative "assets/hook"
    require_relative "assets/logger"
    require_relative "assets/hooks"
    require_relative "assets/liquid"
    require_relative "assets/addons"
  end
end
