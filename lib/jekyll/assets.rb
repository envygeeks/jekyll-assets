# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

# --
# External
# --
require "sprockets"
require "extras/all"
require "jekyll/sanity"
require "pathutil"
require "jekyll"
require "liquid"

def require_all(*globs)
  path = Pathutil.new("assets").expand_path(__dir__)
  globs.each { |v| path.glob(v).reject { |o| o.directory? }.each do |vv|
    require vv
  end }
end

require_all "patches/*", "*", "liquid/*",
    "hooks/*", "plugins/*"
