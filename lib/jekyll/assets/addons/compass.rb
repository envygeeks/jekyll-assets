try_require "compass/core" do
  Jekyll::Assets::Hook.register :env, :init do
    Compass::Frameworks::ALL.each do |framework|
      append_path framework.stylesheets_directory
    end
  end
end
