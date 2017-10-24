# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

require "sprockets"
require "pathutil"

module Jekyll
  module Assets
    module Map
      class Writer < Sprockets::Exporters::Base
        def skip?(logger)
          !@environment.asset_config[:source_maps] ||
          !@asset.metadata[:map]
        end

        # --
        def call
          clean_file!
          clean_sources!
          write_map!
          write_src!
        end

        # --
        # Provides our custom manifest key, full of files.
        # @note We push everything from the file we are writing to the maps.
        # @return [Array<String>]
        # --
        def files
          @files ||= begin
            key = "sourceMapFiles"
            out = @environment.manifest.data[key] ||= []
            Manifest.keep_keys << key unless Manifest.keep_keys.include?(key)
            out
          end
        end

        # --
        # @return [HashWithIndifferentAccess]
        # @note do not modify the original map.
        # Provides a modifible SourceMap
        # --
        private
        def map
          @map ||= begin
            map = @asset.metadata[:map]
            HashWithIndifferentAccess.new(map)
          end
        end

        # --
        # @return [HashWithIndifferentAccess]
        # @note this is frozen so you can't modify.
        # Provides an unmodifiable SourceMap
        # --
        private
        def original_map
          @original_map ||= begin
            map = @asset.metadata[:map]
            map = HashWithIndifferentAccess.new(map)
            map.freeze
          end
        end

        # --
        # @note something like _assets/*
        # Makes sure that the name sits in the asset path.
        # @return [String]
        # --
        private
        def clean_file!
          map[:file] = base.join(map[:file]).to_s
        end

        # --
        private
        def clean_sources!
          if map[:sources]
            then map[:sources] = map[:sources].map do |v|
              base.join(strip_src(v))
            end
          else
            map[:sections].each do |v|
              v[:map][:sources] = v[:map][:sources].map do |vv|
                base.join(strip_src(vv))
              end
            end
          end

          map
        end

        # --
        def strip_src(path)
          path = Pathutil.new(path)
          base = path.basename.gsub(/\.source/, "")
          return path.dirname.join(base).to_s unless path.dirname == "."
          base.to_s if path.dirname == "."
        end

        # --
        # @note we shim this on name.
        # Privates the base directory in the source.
        # @return [String]
        # --
        private
        def base
          Pathutil.new(asset.filename.sub(environment.jekyll.
            in_source_dir + "/", "")).dirname
        end

        # --
        private
        def map_files
          return original_map[:sources] if original_map.key?(:sources)
          original_map[:sections].map { |v| v[:map][:sources] \
            if v.key?(:map) }.flatten.compact
        end

        # --
        def write_map!
          path = Map.map_path(asset: asset, env: environment)
          write(environment.in_dest_dir(path)) do |f|
            files.push(path)
            f.write(map.to_json)
            files.uniq!
          end
        end

        # --
        def strip_base(asset)
          return asset if asset.is_a?(Sprockets::Asset)
          asset.sub(base + "/", "")
        end

        def write_src!
          asset = base.join(@environment.strip_paths(@asset.filename))
          [asset, map_files].flatten.compact.uniq.each do |v|
            source = environment.find_source!(strip_base(v))
            path = base.join(environment.strip_paths(source.filename))
            path = Map.path(asset: path, env: environment)

            write(environment.in_dest_dir(path)) do |f|
              files.push(path.to_s)
              f.write(source.source)
              files.uniq!
            end
          end
        end
      end

      Sprockets.register_exporter "*/*", Writer
    end
  end
end
