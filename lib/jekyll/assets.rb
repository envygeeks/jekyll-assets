# ----------------------------------------------------------------------------
# Frozen-string-literal: true
# Copyright: 2012 - 2016 - MIT License
# Encoding: utf-8
# ----------------------------------------------------------------------------

require "sprockets"
require "extras/all"
require "jekyll"

require_relative "assets/env"
require_relative "assets/version"
require_relative "assets/patches"
require_relative "assets/config"
require_relative "assets/cached"
require_relative "assets/hook"
require_relative "assets/logger"
require_relative "assets/hooks"
require_relative "assets/liquid"
require_relative "assets/addons/less"
require_relative "assets/addons/bootstrap"
require_relative "assets/addons/autoprefixer"
require_relative "assets/addons/font_awesome"
require_relative "assets/addons/javascript"
require_relative "assets/processors/liquid"
require_relative "assets/proxies/magick"
