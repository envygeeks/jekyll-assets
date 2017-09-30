# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

module Jekyll
  module Assets
    module Patches
      module Jekyll
        module Cleaner

          # --
          # obsolete_files patches Jekyll's obsolete_files so
          # that we can prevent our assets from being deleted when
          # it does it's own cleanup.
          # @return [Array]
          # --
          def obsolete_files
            super.delete_if do |v|
              v.start_with?(site.in_dest_dir(site.sprockets.prefix_path))
            end
          end
        end
      end
    end
  end
end

module Jekyll
  class Cleaner
    prepend Jekyll::Assets::Patches::Jekyll::Cleaner
  end
end
