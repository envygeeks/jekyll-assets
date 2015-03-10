# 3rd-party
require "sprockets"
require "mini_magick"

module Jekyll
  module Assets
    module Patches
      module AssetPatch
        def self.included(base)
          base.send :extend, ClassMethods
          base.send :include, InstanceMethods
        end

        module ClassMethods
          def mtimes
            @mtimes ||= {}
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

          def destination(dest)
            File.join dest, site.assets_config.dirname, filename
          end

          def filename
            case cachebust = site.assets_config.cachebust
            when :none, :soft then logical_path
            when :hard        then digest_path
            else fail "Unknown cachebust strategy: #{cachebust.inspect}"
            end
          end

          def modified?
            self.class.mtimes[pathname.to_s] != mtime.to_i
          end

          def write(dest)
            dest_path = destination dest

            return false if File.exist?(dest_path) && !modified?
            self.class.mtimes[pathname.to_s] = mtime.to_i

            write_to dest_path
            write_to "#{dest_path}.gz" if gzip?

            true
          end

          def gzip?
            site.assets_config.gzip.include? content_type
          end

          def extname
            @extname ||= File.extname(pathname)
          end

          def basename
            @basename ||= File.basename(pathname, extname)
          end

          def resize_outdir
            site.assets.resize_cache_path
          end

          def ensure_resize_directory!
            FileUtils.mkdir_p resize_outdir
          end

          def do_resize(dimensions)
            name = "#{basename}-#{dimensions}#{extname}".gsub(/%/, "P")
            img = MiniMagick::Image.read(to_s, extname)
            img.resize dimensions
            img.write "#{resize_outdir}/#{name}"

            [name, site.assets[name]]
          end

          def resize(dimensions)
            ensure_resize_directory!

            @outfiles ||= {}

            @outfiles[dimensions] ||= do_resize(dimensions)
          end
        end
      end
    end
  end
end

Sprockets::Asset.send :include, Jekyll::Assets::Patches::AssetPatch
