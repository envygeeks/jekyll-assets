# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

require "pathutil"
require "jekyll"

def require_all(*globs)
  path = Pathutil.new("assets").expand_path(__dir__)
  globs.each { |v| path.glob(v).reject { |o| o.directory? }.each do |vv|
    require vv
  end }
end

require_relative "assets/env"
Jekyll::Hooks.register :site, :post_read do |o|
  Jekyll::Assets::Env.new(o)
end
