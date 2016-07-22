module Jekyll
  module Assets
    module Processors
      class Liquid
        FOR = %W(
          text/css text/sass text/less application/javascript
          text/scss text/coffeescript text/javascript).freeze
        EXT = %W(.liquid .js.liquid .css.liquid .scss.liquid).freeze

        # --------------------------------------------------------------------

        def self.call(context, jekyll = context[:environment].jekyll)
          if context[:environment].parent.asset_config["features"]["liquid"] ||
              File.extname(context[:filename]) == ".liquid"

            payload_ = jekyll.site_payload
            renderer = jekyll.liquid_renderer.file(context[:filename])
            context[:data] = renderer.parse(context[:data]).render! payload_, \
              :filters => [Jekyll::Filters],
              :registers => {
                :site => jekyll
              }
          end
        end
      end
    end
  end
end

# ----------------------------------------------------------------------------
# There might be a few missing, if there is please do let me know.
# ----------------------------------------------------------------------------

Jekyll::Assets::Processors::Liquid::EXT.each do |ext|
  Sprockets.register_engine(ext, Jekyll::Assets::Processors::Liquid, {
    :silence_deprecation => true
  })
end

# ----------------------------------------------------------------------------

Jekyll::Assets::Processors::Liquid::FOR.each do |val|
  Sprockets.register_preprocessor(
    val, Jekyll::Assets::Processors::Liquid
  )
end
