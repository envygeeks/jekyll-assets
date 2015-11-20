# Frozen-string-literal: true
# Copyright: 2012-2015 - MIT License
# Encoding: utf-8

module Jekyll
  module Assets
    module Liquid
      class Tag
        module Defaults
          class Image
            def self.is_for?(tag)
              tag == "img" || tag == "image"
            end

            # TODO: In 3.0 env needs to be enforced if this is not changed,
            #   for now it's not enforced to maintain the 2.0 API.

            def initialize(args, asset, env = nil)
              @asset = asset
              @env   =   env
              @args  =  args
            end

            #

            def set!
              set_img_dimensions
              set_img_alt
            end

            # TODO: 3.0 - Remove the `!@env`

            private
            def set_img_alt
              if !@env || @env.asset_config["features"]["automatic_img_alt"]
                @args[:html] ||= {}
                if !@args[:html].has_key?("alt")
                  then @args[:html]["alt"] = @asset.logical_path
                end
              end
            end

            # TODO: 3.0 - Remove the `!@env`

            private
            def set_img_dimensions
              if !@env || @env.asset_config["features"]["automatic_img_size"]
                dimensions = FastImage.new(@asset.filename).size
                return unless dimensions
                @args[:html] ||= {}

                @args[:html][ "width"] ||= dimensions.first
                @args[:html]["height"] ||= dimensions. last
              end
            end
          end
        end
      end
    end
  end
end
