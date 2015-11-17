module Jekyll
  module Assets
    module Liquid
      class Tag
        module Defaults
          class Image
            def self.is_for?(tag)
              tag == "img" || tag == "image"
            end

            #

            def initialize(args, asset)
              @asset = asset
              @args  =  args
            end

            #

            def set!
              set_img_dimensions
              set_img_alt
            end

            #

            private
            def set_img_alt
              @args[:html] ||= {}
              if !@args[:html].has_key?("alt")
                then @args[:html]["alt"] = @asset.logical_path
              end
            end

            #

            private
            def set_img_dimensions
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
