# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

require "sprockets"

module Jekyll
  module Assets
    module Map
      class JavaScript < Sprockets::UglifierCompressor
        def call(input)
          out = super(input)
          env = input[:environment]
          asset = env.find_asset!(input[:filename], pipeline: :source)
          path = asset.filename.sub(env.jekyll.in_source_dir + "/", "")
          url = Map.map_path(asset: asset, env: env)
          url = env.prefix_url(url)

          out.update({
            data: <<~TXT
              #{input[:data].strip}
              //# sourceMappingURL=#{url}
              //# sourceURL=#{path}
            TXT
          })
        end
      end

      content_type = "application/javascript"
      Sprockets.register_compressor content_type, \
        :source_map, JavaScript
    end
  end
end
