# rubocop:disable Naming/FileName
# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

Jekyll::Assets::Utils.try_require "font-awesome-sass" do
  FontAwesome::Sass.load!
end
