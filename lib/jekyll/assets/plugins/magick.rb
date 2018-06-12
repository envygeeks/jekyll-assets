# Frozen-string-literal: true
# Copyright: 2012 - 2018 - MIT License
# Author: Jordon Bedwell
# Encoding: utf-8

Jekyll::Assets::Utils.activate("mini_magick") do
  require_relative "proxy/magick"
end
