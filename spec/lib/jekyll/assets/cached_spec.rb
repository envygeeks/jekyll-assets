require "rspec/helper"
describe Jekyll::Assets::Cached do
  let :site do
    stub_jekyll_site
  end

  let :env do
    Jekyll::Assets::Env.new(
      site
    )
  end

  let :cached do
    Jekyll::Assets::Cached.new(
      env
    )
  end

  it "adds jekyll" do
    expect(cached).to respond_to(
      :jekyll
    )
  end

  context :parent do
    it "is an Environment" do
      expect(cached.parent).to be_kind_of(
        Jekyll::Assets::Env
      )
    end

    it "responds" do
      expect(cached).to respond_to(
        :parent
      )
    end
  end
end
