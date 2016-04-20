# ----------------------------------------------------------------------------
# Frozen-string-literal: true
# Copyright: 2012 - 2016 - MIT License
# Encoding: utf-8
# ----------------------------------------------------------------------------

require "sprockets/helpers"
Jekyll::Assets::Hook.register :env, :init do
  Sprockets::Helpers.configure do |config|
    config.manifest = manifest
    config.prefix = prefix_path
    config.digest = digest?
  end
end
