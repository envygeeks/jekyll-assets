# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

require "pathutil"
require "jekyll"

# --
# rubocop:disable Layout/BlockEndNewline
# rubocop:disable Layout/MultilineBlockLayout
# rubocop:disable Style/BlockDelimiters
# --
def require_all(*globs)
  path = Pathutil.new("assets").expand_path(__dir__)
  globs.each { |v| path.glob(v).reject(&:directory?).each do |vv|
    require vv
  end }
end

require_relative "assets/env"
Jekyll::Hooks.register(:site, :post_read) {  |o| Jekyll::Assets::Env.new(o) }
Jekyll::Hooks.register :site, :post_write do |o|
  o&.sprockets&.write_all
end
