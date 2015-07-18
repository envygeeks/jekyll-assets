guard :rspec, cmd: "bundle exec rspec" do require "guard/rspec/dsl"
  dsl   = Guard::RSpec::Dsl.new(self); rspec = dsl.rspec; ruby = dsl.ruby
  dsl.watch_spec_files_for(ruby.lib_files)
  watch(rspec.spec_files)

  watch(rspec.spec_helper) do
    rspec.spec_dir
  end

  watch(rspec.spec_support) do
    rspec.spec_dir
  end
end
