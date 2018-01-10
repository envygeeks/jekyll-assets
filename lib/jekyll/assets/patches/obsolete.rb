# Frozen-string-literal: true
# Copyright: 2012 - 2018 - MIT License
# Encoding: utf-8

module Jekyll
  module Assets
    module Patches
      # --
      # Patches Jekyll's obsolete files so that we can
      # remove assets that we have used through the manifest.
      # We expect the user to keep that manifest available,
      # regardless of what's going on in their stuff.
      # --
      module ObsoleteFiles
        # --
        # @param [Object] args whatever Jekyll takes.
        # Gives a list of files that should be removed, unless used.
        # @return [Array<String>]
        # --
        def obsolete_files(*args)
          extras = Utils.manifest_files(site.sprockets)
          extras.concat(site.sprockets.raw_precompiles
            .map { |v| v.values_at(:dst, :full_dst) }
              .flatten.uniq)

          super(*args).reject do |v|
            v == site.sprockets.in_dest_dir || \
              v == site.sprockets.manifest.filename || \
              extras.include?(v)
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
