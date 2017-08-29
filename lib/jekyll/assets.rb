# Frozen-string-literal: true
# Copyright: 2012 - 2016 - MIT License
# Encoding: utf-8

require "sprockets"
require "extras/all"
require "pathutil"
require "jekyll"

requires = [ :liquid,
  :patches, "", :hooks, :addons,
  :proxies, :processors]

requires.each do |part|
  Pathutil.new(__dir__).join('assets', part.to_s)
    .glob('{*,**/*}.rb').map(&method(
      :require
))
end
