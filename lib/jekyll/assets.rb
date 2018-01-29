# Frozen-string-literal: true
# Copyright: 2012 - 2018 - MIT License
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

# --
require_relative "assets/env"
Jekyll::Hooks.register :site, :post_read, priority: 99 do |o|
  unless o.sprockets
    Jekyll::Assets::Env.new(o)
  end
end

# --
# Post render hook.
# We need to run really early because we want to have our
#   stuff block and be done just incase something else relies
#   on our stuff to do their stuff.  Such as reloaders.
# --
Jekyll::Hooks.register :site, :post_write, priority: 99 do |o|
  o&.sprockets&.write_all
end
