# Frozen-string-literal: true
# Copyright: 2012 - 2018 - MIT License
# Author: Jordon Bedwell
# Encoding: utf-8

Jekyll::Assets::Utils.activate "bootstrap"
Jekyll::Assets::Utils.activate "bootstrap-sass" do
  Bootstrap.load!
end
