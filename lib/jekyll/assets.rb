# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License

require "pathutil"
require "jekyll"

def require_all(*globs)
  path = Pathutil.new("assets").expand_path(__dir__)
  globs.each do |v|
    path.glob(v).reject(&:directory?).each do |vv|
      require vv
    end
  end
end

require_relative "assets/env"
Jekyll::Hooks.register :site, :post_read do |o|
  Jekyll::Assets::Env.new(o)
end
