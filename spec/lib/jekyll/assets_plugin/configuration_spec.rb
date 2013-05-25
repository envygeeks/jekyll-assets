require "spec_helper"


module Jekyll::AssetsPlugin
  describe Configuration do
    context "with defaults" do
      let(:config){ Configuration.new }

      context "output assets dirname" do
        subject { config.dirname }
        it { should == Configuration::DEFAULTS[:dirname] }
      end

      context "assets baseurl" do
        subject { config.baseurl }
        it { should == "/" + Configuration::DEFAULTS[:dirname] }
      end

      context "sources list" do
        subject { config.sources }
        it { should =~ Configuration::DEFAULTS[:sources] }
      end

      context "cachebust" do
        subject { config.cachebust }
        it { should == :hard }
      end

      context "js compressor" do
        subject { config.compress.js }
        it { should be_nil }
      end

      context "css compressor" do
        subject { config.compress.css }
        it { should be_nil }
      end

      context "gzip" do
        subject { config.gzip }
        it { should =~ %w{ text/css application/javascript } }
      end

      context "cache_assets?" do
        subject { config.cache_assets? }
        it { should be_true }
      end

    end

    it "should override specified options and leave defaults for missing" do
      config = Configuration.new({
        :sources  => %w{abc},
        :compress => { :css => "sass" }
      })

      config.dirname.should       ==  "assets"
      config.sources.should       =~  %w{abc}
      config.compress.js.should       be_nil
      config.compress.css.should  ==  "sass"
    end

    context "#baseurl" do
      it "should respect explicit overrides" do
        Configuration.new({
          :dirname => "foo",
          :baseurl => "/bar/"
        }).baseurl.should == "/bar"
      end

      it "should be auto-guessed from dirname" do
        Configuration.new({
          :dirname => "foo"
        }).baseurl.should == "/foo"
      end
    end

    context "#js_compressor" do
      context "when js compressor is given as `uglify`" do
        let(:config){ Configuration.new(:compress => {:js => "uglify"}) }
        subject { config.js_compressor }
        it { should be :uglify }
      end

      context "otherwise" do
        let(:config){ Configuration.new }
        subject { config.js_compressor }
        it { should be_false }
      end
    end

    context "#css_compressor" do
      context "when css compressor is given as `sass`" do
        let(:config){ Configuration.new(:compress => {:css => "sass"}) }
        subject { config.css_compressor }
        it { should be :sass }
      end

      context "otherwise" do
        let(:config){ Configuration.new }
        subject { config.css_compressor }
        it { should be_false }
      end
    end

    context "#gzip" do
      context "when gzip is disabled" do
        let(:config){ Configuration.new(:gzip => false) }
        subject { config.gzip }
        it { should == [] }
      end
    end
  end
end
