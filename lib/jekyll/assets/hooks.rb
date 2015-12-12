# Frozen-string-literal: true
# Copyright: 2012-2015 - MIT License
# Encoding: utf-8

require_relative "hooks/jekyll/drops"
require_relative "hooks/jekyll/setup"
require_relative "hooks/jekyll/write"

require_relative "hooks/compression"
require_relative "hooks/configuration"
require_relative "hooks/context_patches"
require_relative "hooks/disable_erb"
require_relative "hooks/helpers"
require_relative "hooks/logger"
require_relative "hooks/sources"
require_relative "hooks/sprockets"
require_relative "hooks/version"
require_relative "hooks/cache"
