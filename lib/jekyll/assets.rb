# Frozen-string-literal: true
# Copyright: 2012-2015 - MIT License
# Encoding: utf-8

autoload :Tilt, "tilt"
require "sprockets"
require "jekyll"

require "jekyll/assets/patches"
require "jekyll/assets/version"

module Jekyll
  module Assets
    autoload :Hook,   "jekyll/assets/hook"
    autoload :Cached, "jekyll/assets/cached"
    autoload :Config, "jekyll/assets/config"
    autoload :Logger, "jekyll/assets/logger"
    autoload :Liquid, "jekyll/assets/liquid"
    autoload :Env,    "jekyll/assets/env"

    require "jekyll/assets/hooks"
    require "jekyll/assets/addons"
  end
end
