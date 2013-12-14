# 3rd-party
require "sprockets"


module Jekyll
  module AssetsPlugin
    module Patches
      module AssetPatch

        def self.included base
          base.send :extend, ClassMethods
          base.send :include, InstanceMethods
        end


        module ClassMethods

          def mtimes
            @mtimes ||= Hash.new
          end

        end


        module InstanceMethods

          attr_reader :site


          def jekyll_assets
            []
          end


          def bundle!
            site.bundle_asset! self if site
            self
          end


          def destination dest
            File.join dest, site.assets_config.dirname, filename
          end


          def filename
            case cachebust = site.assets_config.cachebust
            when :none, :soft then logical_path
            when :hard        then digest_path
            else raise "Unknown cachebust strategy: #{cachebust.inspect}"
            end
          end


          def modified?
            self.class.mtimes[pathname.to_s] != mtime.to_i
          end


          def write dest
            dest_path = destination dest

            return false if File.exist?(dest_path) and !modified?
            self.class.mtimes[pathname.to_s] = mtime.to_i

            write_to dest_path
            write_to "#{dest_path}.gz" if gzip?

            write_to destination(site.source) if precompile?
            write_to "#{destination(site.source)}.gz" if gzip? && precompile?

            true
          end


          def gzip?
            site.assets_config.gzip.include? content_type
          end


          def precompile?
            site.assets_config.precompile
          end

        end

      end
    end
  end
end


Sprockets::Asset.send :include, Jekyll::AssetsPlugin::Patches::AssetPatch
