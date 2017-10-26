# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

require "jekyll/assets"

Jekyll::Assets::Utils.javascript? do
  Jekyll::Assets::Utils.try_require "autoprefixer-rails" do
    Jekyll::Assets::Hook.register :config, :before_merge do |c|
      c.deep_merge!({
        plugins: {
          css: {
            autoprefixer: {
              # Your config here.
            },
          },
        },
      })
    end

    Jekyll::Assets::Hook.register :env, :after_init do
      config = asset_config[:plugins][:css][:autoprefixer]
      AutoprefixerRails.install(self, jekyll.safe ? config : {
        # Your configuration here.
      })
    end
  end
end
