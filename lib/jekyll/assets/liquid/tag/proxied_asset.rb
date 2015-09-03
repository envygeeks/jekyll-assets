# ----------------------------------------------------------------------------
# Frozen-string-literal: true
# Copyright: 2012 - 2016 - MIT License
# Encoding: utf-8
# ----------------------------------------------------------------------------

require "forwardable"

module Jekyll
  module Assets
    module Liquid
      class Tag
        class ProxiedAsset
          attr_reader :args, :asset, :env
          extend Forwardable

          # ------------------------------------------------------------------

          attr_reader :content_type

          def_delegator :@asset, :liquid_tags
          def_delegator :@asset, :source_filename
          def_delegator :@asset, :mtime

          # ------------------------------------------------------------------

          def initialize(asset, args, env, tag)
            @env = env
            @asset = asset.dup
            @args = args
            @tag = tag
            @path = Pathutil.new(asset.logical_path)
            @content_type = asset.content_type

            cache_file
            proxy_file
          end

          # ------------------------------------------------------------------

          def integrity
            Sprockets::DigestUtils.integrity_uri(
              digest
            )
          end

          # ------------------------------------------------------------------

          def cached?
            @_cached
          end

          # ------------------------------------------------------------------

          def write_to(name)
            FileUtils.mkdir_p File.dirname(name)
            Sprockets::PathUtils.atomic_write(name) do |f|
              f.write source
            end
          end

          # ------------------------------------------------------------------

          def source
            filename.binread
          end

          # ------------------------------------------------------------------

          def filename
            Pathutil.new(
              env.in_cache_dir(digest_path)
            )
          end

          # ------------------------------------------------------------------

          def digest
            Digest::SHA2.hexdigest(
              args.proxies.to_s
            )
          end

          # ------------------------------------------------------------------

          def content_type=(type)
            return if @content_type == type

            @path = @path.sub_ext(_ext_for(type))
            @content_type = type
          end

          # ------------------------------------------------------------------
          # We always digest a proxied asset so it's uniq based on what
          # proxies you give us, it would be ignorant to treat it otherwise,
          # we also make sure they are URL safe by digesting the args.
          # ------------------------------------------------------------------

          def logical_path
            digest_path
          end

          # ------------------------------------------------------------------

          def digest_path
            "#{@path.sub_ext ""}-#{digest}#{@path.extname}"
          end

          # --------------------------------------------------------------------

          private
          def _mime_for(ext)
            Sprockets.mime_exts[
              ext
            ]
          end

          # --------------------------------------------------------------------

          private
          def _ext_for(type)
            Sprockets.mime_types[type][:extensions].first
          end

          # ------------------------------------------------------------------

          private
          def proxy_file
            unless cached?
              args.proxies.each do |key, val|
                old_type = content_type
                old_filename = filename
                Proxies.get(key).first[:class].new(self, val, @args).process
                old_filename.rm if old_type != content_type
              end
            end
          end

          # ------------------------------------------------------------------

          private
          def find_cached
            glob = filename.dirname.glob(filename.basename.sub_ext('.*'))
            @_cached = filename.dirname.directory? && !glob.first.nil?
            if @_cached
              self.content_type = _mime_for(File.extname(glob.first))
            end

            @_cached
          end

          # ------------------------------------------------------------------

          private
          def cache_file
            return true if @_cached || find_cached

            filename.dirname.mkdir_p
            Pathutil.new(asset.filename).cp filename
            true
          end
        end
      end
    end
  end
end
