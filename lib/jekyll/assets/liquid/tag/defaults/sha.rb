# Frozen-string-literal: true
# Copyright: 2012 - 2016 - MIT License
# Encoding: utf-8

module Jekyll
  module Assets
    module Liquid
      class Tag
        module Defaults
          class Sha

            # --
            # What we plan to accept for.
            # --
            def self.for?(tag)
              return tag == "css" || tag == "js"
            end

            # --
            # Initialize a new instance.
            # --
            def initialize(args, asset, env)
              @args = args
              @asset = asset
              @env = env
            end

            # --
            # Run the defaults.
            # --
            def set!
              set_integrity
            end

            # --
            # Set the integrity attribute.
            # @return [nil]
            # --
            def set_integrity
              @args.args[:html] ||= {}
              if @env.asset_config["features"]["integrity"]
                @args.args[:html]["integrity"] = @asset.integrity
                @args.args[:html]["crossorigin"] = "anonymous" \
                  unless @args.args[:html]["crossorigin"]
              end
            end
          end
        end
      end
    end
  end
end
