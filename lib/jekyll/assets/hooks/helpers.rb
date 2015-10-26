require "sprockets/helpers"

Jekyll::Assets::Hook.register :env, :init do
  Sprockets::Helpers.configure do |config|
    config.prefix = prefix_path
    config.digest =     digest?
  end
end
