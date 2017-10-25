# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License

require "jekyll/assets"

try_require_if_javascript "autoprefixer-rails" do
  Jekyll::Assets::Hook.register :config, :pre do |c|
    c.deep_merge!({
      plugins: {
        css: {
          autoprefixer: {}
        }
      }
    })
  end

  Jekyll::Assets::Hook.register :env, :init do
    config = asset_config[:plugins][:css][:autoprefixer]
    AutoprefixerRails.install(self, jekyll.safe ?
      config : {})
  end
end
