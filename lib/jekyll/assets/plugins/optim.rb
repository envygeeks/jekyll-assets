# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

Jekyll::Assets::Utils.try_require "image_optim" do
  require_relative "proxy/optim"
end
