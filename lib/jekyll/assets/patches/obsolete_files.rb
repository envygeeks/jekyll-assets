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
          manifest = manifest.values_at(*Manifest.keep_keys).map(&:to_a)
          manifest.flatten.each_with_object([]) do |v, a|
            path = Pathutil.new(site.sprockets.in_dest_dir(v))
            a << path.to_s + ".gz" if path.exist? && !site.sprockets.skip_gzip?
            a << path.to_s if path.exist?
            v = Pathutil.new(v)

            next if v.dirname == "."
            v.dirname.descend.each do |vv|
              vv = site.sprockets.in_dest_dir(vv)
              unless a.include?(vv)
                a << vv
              end
            end
          end
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
