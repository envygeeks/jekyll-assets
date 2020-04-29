# Frozen-string-literal: true
# Copyright: 2012 - 2020 - ISC License
# Author: Jordon Bedwell
# Encoding: utf-8

module Jekyll
  module Assets
    module Plugins
      Hook.register :asset, :after_compression, priority: 3 do |i, o, t|
        next o unless t == "text/css"

        env = i[:environment]
        asset = env.find_asset!(i[:filename], pipeline: :source)
        path = asset.filename.sub(env.jekyll.in_source_dir + "/", "")
        url = SrcMap.map_path(asset: asset, env: env)
        url = env.prefix_url(url)

        <<~CSS
          #{o.strip}
          /*# sourceMappingURL=#{url} */
          /*# sourceURL=#{path} */
        CSS
      end

      # --
      Hook.register :env, :after_init, priority: 1 do
        next if asset_config[:compression]
        if asset_config[:source_maps]
          then asset_config[:compression] = true
        end
      end
    end
  end
end
