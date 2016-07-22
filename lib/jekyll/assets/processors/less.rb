try_require_if_javascript "less" do
  module Jekyll
    module Assets
      module Processors
        class LESS

          # --------------------------------------------------------------------
          # Setup and pull out the context and update the data, shipping it.
          # --------------------------------------------------------------------

          def self.call(input)
            data = input[:data]; paths = [input[:load_path]]
            tree = Less.instance_variable_get(:@loader).require("less/tree")
            context = input[:environment].context_class.new(input)
            patch_tree(tree, context)

            paths |= input[:environment].paths
            paths |= Dir.glob(input[:load_path] + '/*').select(&File.method(:directory?))
            parser = Less::Parser.new(:paths => paths)

            context.metadata.merge({
              :data => Less::Parser.new(:paths => paths) \
                .parse(data).to_css
            })
          end

          # --------------------------------------------------------------------
          # Add the sprockets helpers into the Less environment so people can
          # use assets from within Less... as they see fit.
          # --------------------------------------------------------------------
          # We also make sure to disable their quotes so that we can quote
          # ourselves if we need to, otherwise we simply just take the values.
          # --------------------------------------------------------------------

          def self.patch_tree(tree, context)
            Helpers.instance_methods.each do |m|
              tree.functions[m.to_s.tr("_", "-")] = tree.functions[m.to_s] = lambda do |*args|
                args.last.tap do |o|
                  o[:quote] = ""
                  o[:value] = context.send(m, args.last.toCSS().gsub(
                    /^"|"$/, ""
                  ))

                  if m.to_s.end_with?("_path")
                    o[:value] = o[:value].inspect
                  end
                end
              end
            end
          end
        end
      end
    end
  end

  # ----------------------------------------------------------------------------

  if Gem::Version.new(Sprockets::VERSION) >= Gem::Version.new(4.0)
    Sprockets.register_mime_type "text/less", :extensions => [".less", ".css.less"]
    Sprockets.register_transformer("text/less", "test/css",
      Jekyll::Assets::Processors::LESS
    )
  else
    Sprockets.register_engine(
      ".less", Jekyll::Assets::Processors::LESS, {
        :silence_deprecation => true
      }
    )
  end
end
