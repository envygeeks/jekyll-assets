# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

require "sprockets"
require "extras/all"
require "jekyll/sanity"
require "pathutil"
require "jekyll"

# --
require "jekyll/assets/patches/obsolete_files"
require "jekyll/assets/patches/sprockets_data_uri"
require "jekyll/assets/patches/sprockets"
require "jekyll/assets/patches/kernel"

# --
require "jekyll/assets/version"
require "jekyll/assets/hooks/drops"
require "jekyll/assets/hooks/setup"
require "jekyll/assets/hook"
require "jekyll/assets/cached"
require "jekyll/assets/helpers"
require "jekyll/assets/config"
require "jekyll/assets/logger"
require "jekyll/assets/proxy"
require "jekyll/assets/env"
