require "less"

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
          Sprockets::Helpers.instance_methods.reject { |v| v=~ /^(path_to_|assets_environment$)/ }.each do |m|
            tree.functions[m.to_s.tr("_", "-")] = tree.functions[m.to_s] = lambda do |*args|
              args.last.tap do |o|
                o[:quote] = "" # We handle that ourselves, fuck that.
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

Sprockets.register_engine ".less", Jekyll::Assets::Processors::LESS
