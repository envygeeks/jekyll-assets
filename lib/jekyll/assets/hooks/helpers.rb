# Frozen-string-literal: true
# Copyright: 2012-2015 - MIT License
# Encoding: utf-8

require "sprockets/helpers"

Jekyll::Assets::Hook.register :env, :init do
  Sprockets::Helpers.configure do |config|
    config.prefix = prefix_path
    config.digest = digest?
  end
end
