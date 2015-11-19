module Jekyll
  module Assets
    module Addons
      module Processors
        class Liquid < Tilt::Template
          ProcessingFor = %W(
            text/css text/sass text/less text/scss
            text/coffeescript text/javascript
          )

          def prepare
            #
          end

          # Render the file with the sites current context, anything you
          # can do in a normal liquid file with Jekyll, you can do here inc,
          # accessing the entirety of your posts and pages, though I don't
          # know why you would want to, and I ain't judging you.

          def evaluate(scope, locals, jekyll = scope.environment.jekyll, &block)
            jekyll.liquid_renderer.file(@file).parse(data).render!(
              jekyll.site_payload, :registers => {
                :site => jekyll
              }
            )
          end
        end
      end
    end
  end
end

# There might be a few missing, if there is please do let me know.
Jekyll::Assets::Addons::Processors::Liquid::ProcessingFor.each do |val|
  Sprockets.register_preprocessor val, Jekyll::Assets::Addons::Processors::Liquid
end
