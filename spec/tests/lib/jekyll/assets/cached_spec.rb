# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License

require "rspec/helper"
describe Jekyll::Assets::Cached do
  let :path do
    site.in_dest_dir("/assets")
  end

  #

  it { respond_to(:manifest) }
  it { respond_to(:asset_config) }
  it { respond_to(:uncached) }
  it { respond_to(:jekyll) }

  #

  describe "#uncached" do
    subject do
      env
    end

    it "should be the environment" do
      expect(subject.cached.uncached).to(eq(subject))
    end
  end
end
