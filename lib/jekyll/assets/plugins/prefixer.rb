# Frozen-string-literal: true
# Copyright: 2012 - 2018 - MIT License
# Author: Jordon Bedwell
# Encoding: utf-8

Jekyll::Assets::Utils.javascript? do
  Jekyll::Assets::Utils.activate "autoprefixer-rails" do
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

    Jekyll::Assets::Hook.register :env, :after_init, priority: 1 do
      config = asset_config[:plugins][:css][:autoprefixer]
      AutoprefixerRails.install(self, jekyll.safe ? config : {
        # Your configuration here.
      })
    end
  end
end
