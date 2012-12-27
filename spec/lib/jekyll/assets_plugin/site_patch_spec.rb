require 'spec_helper'


module Jekyll::AssetsPlugin
  describe SitePatch do
    let(:site) do
      Class.new do
        include SitePatch

        def config
          @config ||= {
            'bundles' => 'foobar',
            'assets'  => { 'sources' => 'foobar' }
          }
        end

        def source
          @soure ||= '.'
        end
      end.new
    end

    context '#assets' do
      subject { site.assets }
      it { should be_an_instance_of Sprockets::Environment }
    end

    context '#assets_config' do
      subject { site.assets_config }
      it { should be_an_instance_of Configuration }

      it 'should been populated with `assets` section of config' do
        site.assets_config.bundles.should_not =~ %w{foobar}
        site.assets_config.sources.should =~ %w{foobar}
      end
    end

    it 'should be included into Jekyll::Site' do
      Jekyll::Site.included_modules.should include SitePatch
    end
  end
end
