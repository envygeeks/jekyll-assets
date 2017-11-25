# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

Jekyll::Assets::Utils.try_require "bootstrap"
Jekyll::Assets::Utils.try_require "boostrap-sass" do
  Bootstrap.load!
end
