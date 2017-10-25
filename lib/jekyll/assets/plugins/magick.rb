# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

Jekyll::Assets::Utils.try_require "mini_magick" do
  require_relative "proxy/magick"
end
