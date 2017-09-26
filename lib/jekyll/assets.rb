# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

require "sprockets"
require "extras/all"
require "pathutil"
require "jekyll"

[:liquid, :patches, "", :hooks, :addons, :proxies, :processors].each do |v|
  Pathutil.new(__dir__).join('assets', v.to_s).glob('{*,**/*}.rb')
    .map(&method(:require))
end
