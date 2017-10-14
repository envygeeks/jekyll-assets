# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

module Jekyll
  module Assets
    module Patches
      module ObsoleteFiles

        # --
        # @note we don't want our files removed.
        # obsolete_files patches Jekyll's obsolete_files
        # @return [Array]
        # --
        def obsolete_files
          sprockets, manifest = site.sprockets, site.sprockets.manifest
          reject = manifest.files.keys.map do |v|
            asset = sprockets.in_dest_dir(v)
            [asset+".gz",asset+".map",asset]
          end

          reject.flatten!
          super.reject do |v|
            v == manifest.filename || \
            v == sprockets.in_dest_dir || \
            reject.include?(v)
          end
        end
      end
    end
  end
end

# --
module Jekyll
  class Cleaner
    prepend Jekyll::Assets::Patches::ObsoleteFiles
  end
end
