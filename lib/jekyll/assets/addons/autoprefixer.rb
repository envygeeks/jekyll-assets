# Frozen-string-literal: true
# Copyright: 2012 - 2016 - MIT License
# Encoding: utf-8

try_require_if_javascript "autoprefixer-rails" do
  Jekyll::Assets::Hook.register :env, :init do |env|
    AutoprefixerRails.install(env, env.asset_config[
      "autoprefixer"
    ])
  end
end
