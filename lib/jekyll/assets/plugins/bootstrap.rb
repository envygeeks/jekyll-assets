# Frozen-string-literal: true
# Copyright: 2012 - 2018 - MIT License
# Encoding: utf-8

Jekyll::Assets::Utils.activate "bootstrap"
Jekyll::Assets::Utils.activate "boostrap-sass" do
  Bootstrap.load!
end
