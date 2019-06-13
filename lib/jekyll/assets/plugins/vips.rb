# Frozen-string-literal: true
# Copyright: 2019 - MIT License
# Author: Andrew Heberle
# Encoding: utf-8

Jekyll::Assets::Utils.activate("ruby-vips") do
    require_relative "proxy/vips"
  end
