require 'spec_helper'


module Jekyll::AssetsPlugin
  describe Configuration do
    let(:defaults) do
      {
        :dirname  => 'assets',
        :sources  => %w{_assets/javascripts _assets/stylesheets _assets/images},
        :bundles  => %w{app.css app.js **.jpg **.png **.gif}
      }
    end

    context 'with defaults' do
      let(:config){ Configuration.new }

      context 'output assets dirname' do
        subject { config.dirname }
        it { should == defaults[:dirname] }
      end

      context 'sources list' do
        subject { config.sources }
        it { should =~ defaults[:sources] }
      end

      context 'bundles list' do
        subject { config.bundles }
        it { should =~ defaults[:bundles] }
      end

      context 'js compressor' do
        subject { config.compress.js }
        it { should be_nil }
      end

      context 'css compressor' do
        subject { config.compress.css }
        it { should be_nil }
      end
    end

    it 'should override specified options and leave defaults for missing' do
      config = Configuration.new({
        :sources  => %w{abc},
        :compress => { :css => 'sass' }
      })

      config.dirname.should == 'assets'
      config.sources.should =~ %w{abc}
      config.bundles.should =~ defaults[:bundles]
      config.compress.js.should be_nil
      config.compress.css.should == 'sass'
    end

    context '#js_compressor' do
      context 'when js compressor is given as "uglify"' do
        let(:config){ Configuration.new(:compress => {:js => 'uglify'}) }
        subject { config.js_compressor }
        it { should be :uglify }
      end

      context 'otherwise' do
        let(:config){ Configuration.new }
        subject { config.js_compressor }
        it { should be_false }
      end
    end

    context '#css_compressor' do
      context 'when js compressor is given as "sass"' do
        let(:config){ Configuration.new(:compress => {:css => 'sass'}) }
        subject { config.css_compressor }
        it { should be :sass }
      end

      context 'otherwise' do
        let(:config){ Configuration.new }
        subject { config.css_compressor }
        it { should be_false }
      end
    end
  end
end
