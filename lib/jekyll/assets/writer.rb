# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

unless Jekyll::Assets::Env.old_sprockets?
  require "sprockets/exporters/base"

  module Sprockets
    module Exporters
      class FileExporter < Exporters::Base
        def skip?(logger)
          dest = environment.in_dest_dir + "/"
          out, pth = nil, target.sub(dest, "")

          if File.exist?(target)
            logger.debug "Skips #{pth}" do
              out = true
            end
          else
            logger.debug "Write #{pth}" do
              out = false
            end
          end

          out
        end

        def call
          write target do |f|
            f.write asset.source
          end
        end
      end
    end
  end
end
