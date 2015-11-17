module Jekyll
  module Assets
    module Liquid
      class Tag
        module Defaults
          require_relative "defaults/image"

          module_function
          def set_defaults_for!(tag, args, asset)
            constants.select { |const| const_get(const).is_for?(tag) }.each do |const|
              const_get(const).new(args, asset).set!
            end
          end
        end
      end
    end
  end
end
