require 'sprockets/exporters/base'

module Jekyll
  module Assets
    class SourceMapWriter < Sprockets::Exporters::Base
      def skip?(logger)
        exists = File.exist?(target)
        logger.debug "Skipping #{target}.map, already exists" if exists
        return :skip_this_asset_map if exists
        logger.info "Write #{target}.map"
        false
      end

      def call
        if asset.metadata[:map]
          write("#{target}.map") do |f|
            f.write(asset.metadata[:map].to_json)
          end
        end
      end
    end
  end
end

Sprockets.register_exporter "*/*", Jekyll::Assets::SourceMapWriter
Jekyll::Assets::Hook.register :asset, :compile do |a, m|
  # require"pry"
  # Pry.output = STDOUT
  # binding.pry

  if a.metadata[:map]
    # m.files[target + ".map"] = {
    #   "mtime" => Time.now.to_s,
    #   "digest" => Sprockets::DigestUtils.hexdigest(data),
    #   "logical_path" => logical_map_path,
    #   "size" => data.size,
    # }
  end
end
