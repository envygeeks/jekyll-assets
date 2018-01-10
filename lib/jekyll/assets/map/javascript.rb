# Frozen-string-literal: true
# Copyright: 2012 - 2018 - MIT License
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

        def self.register_on(instance)
          content_type = "application/javascript"
          instance.register_compressor(content_type,
            :source_map, self)
        end
      end

      # --
      # We load late in some cases.
      # You can also register it in a Hook.
      # Globally Register it.
      # --
      JavaScript.register_on(Sprockets)
    end
  end
end
