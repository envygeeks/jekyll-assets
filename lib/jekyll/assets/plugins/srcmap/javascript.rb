# Frozen-string-literal: true
# Copyright: 2012 - 2018 - MIT License
# Encoding: utf-8

require "sprockets"

module Jekyll
  module Assets
    module Plugins
      Hook.register :asset, :after_compression, priority: 3 do |i, o, t|
        next unless t == "application/javascript"

        env = i[:environment]
        asset = env.find_asset!(i[:filename], pipeline: :source)
        path = asset.filename.sub(env.jekyll.in_source_dir + "/", "")
        url = SrcMap.map_path(asset: asset, env: env)
        url = env.prefix_url(url)

        o.update({
          data: <<~TXT
            #{o[:data].strip}
            //# sourceMappingURL=#{url}
            //# sourceURL=#{path}
          TXT
        })
      end
    end
  end
end
