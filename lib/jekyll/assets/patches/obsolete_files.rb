# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

module Jekyll
  module Assets
    module Patches
      module ObsoleteFiles
        def obsolete_files
          extra = manifest_files.tap(&:flatten!)
          super.reject do |v|
            v == site.sprockets.in_dest_dir || \
            v == site.sprockets.manifest.filename || \
            extra.include?(v)
          end
        end

        # --
        # Get all the manifest files.
        # @note this includes dynamic keys, like SourceMaps.
        # @return [Array<String>]
        # --
        def manifest_files
          manifest = site.sprockets.manifest.data
          out = (manifest.keys - %w(files)).map do |v|
            v = manifest[v]
            ret = nil

            if v.is_a?(Hash)
              ret = v.map do |k, vv|
                vv = site.sprockets.in_dest_dir(vv)
                k  = site.sprockets.in_dest_dir( k)

                [
                  vv,
                  vv + ".gz",
                  File.dirname(vv),
                  File.dirname(k),
                  k + ".gz",
                  k,
                ]
              end
            elsif v.is_a?(Array)
              ret = v.map do |k|
                k = site.sprockets.in_dest_dir(k)
                [
                  k + ".gz",
                  File.dirname(k),
                  k,
                ]
              end
            end

            ret
          end

          out.flatten.compact.uniq
        end
      end
    end
  end
end

module Jekyll
  class Cleaner
    prepend Jekyll::Assets::Patches::ObsoleteFiles
  end
end
