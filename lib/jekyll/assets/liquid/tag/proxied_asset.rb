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

          def_delegator :@asset, :liquid_tags
          def_delegator :@asset, :filename, :source_filename
          def_delegator :@asset, :content_type
          def_delegator :@asset, :mtime

          # ------------------------------------------------------------------

          def initialize(asset, args, env, tag)
            @env = env
            @asset = asset
            @args = args
            @tag = tag

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
            File.binread(filename)
          end

          # ------------------------------------------------------------------

          def filename
            env.in_cache_dir(digest_path)
          end

          # ------------------------------------------------------------------

          def digest
            Digest::SHA2.hexdigest(
              args.proxies.to_s
            )
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
            name = asset.logical_path
            ext  = File.extname(name)
            "#{name.chomp(ext)}-#{digest}#{ext}"
          end

          # ------------------------------------------------------------------

          private
          def proxy_file
            unless cached?
              args.proxies.each do |key, val|
                Proxies.get(key).first[:class].new(self, val, @args).process
              end
            end
          end

          # ------------------------------------------------------------------

          private
          def cache_file
            @_cached = File.file?(filename)
            return @_cached if @_cached

            dir = File.dirname(filename)
            FileUtils.mkdir_p dir unless dir == env.in_cache_dir
            FileUtils.cp asset.filename, filename
            true
          end
        end
      end
    end
  end
end
