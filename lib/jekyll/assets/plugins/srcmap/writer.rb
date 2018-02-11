# Frozen-string-literal: true
# Copyright: 2012 - 2018 - MIT License
# Encoding: utf-8

require "sprockets"
require "pathutil"

module Jekyll
  module Assets
    module Plugins
      module SrcMap
        class Writer < Sprockets::Exporters::Base
          alias env environment

          def skip?(_)
            !env.asset_config[:source_maps] ||
              !asset.metadata[:map]
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
              out = env.manifest.data[key] ||= []
              unless Manifest.keep_keys.include?(key)
                Manifest.keep_keys << key
              end

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
            @map ||= asset.metadata[:map]
              .with_indifferent_access
          end

          # --
          # @return [HashWithIndifferentAccess]
          # @note this is frozen so you can't modify.
          # Provides an unmodifiable SourceMap
          # --
          private
          def original_map
            @original_map ||= asset.metadata[:map]
              .with_indifferent_access.freeze
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
          private
          def strip_src(path)
            path = Pathutil.new(path)
            base = path.basename.gsub(%r!\.source!, "")
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
            Pathutil.new(asset.filename.sub(env.jekyll
              .in_source_dir + "/", "")).dirname
          end

          # --
          # rubocop:disable Layout/BlockEndNewline
          # rubocop:disable Layout/MultilineBlockLayout
          # rubocop:disable Style/BlockDelimiters
          # --
          private
          def map_files
            return original_map[:sources] if original_map.key?(:sources)
            original_map[:sections].map { |v| v[:map][:sources] \
              if v.key?(:map) }.flatten.compact
          end

          # --
          # rubocop:enable Layout/BlockEndNewline
          # rubocop:enable Layout/MultilineBlockLayout
          # rubocop:enable Style/BlockDelimiters
          # --
          private
          def write_map!
            path = SrcMap.map_path(asset: asset, env: env)
            write(env.in_dest_dir(path)) do |f|
              files.push(path)
              f.write(map.to_json)
              files.uniq!
            end
          end

          # --
          private
          def strip_base(asset)
            return asset if asset.is_a?(Sprockets::Asset)
            asset.sub(base + "/", "")
          end

          # --
          private
          def write_src!
            [asset_path, map_files].flatten.compact.uniq.each do |v|
              next unless (v = env.find_asset(strip_base(v), pipeline: :source))
              path = map_path(v.filename)

              write(environment.in_dest_dir(path)) do |f|
                f.write(v.source)
                files.push(path.to_s)
                  .uniq!
              end
            end
          end

          # --
          private
          def asset_path
            base.join(env.strip_paths(@asset.filename)).to_s
          end

          # --
          private
          def map_path(file)
            asset = base.join(env.strip_paths(file))
            SrcMap.path({
              asset: asset, env: env
            })
          end
        end

        # --
        Hook.register :env, :after_init, priority: 3 do
          register_exporter("*/*", Writer)
        end
      end
    end
  end
end
