require 'spec_helper'


module Jekyll::AssetsPlugin
  describe AssetFile do
    context '#destination' do
      let(:file) { AssetFile.new(@site, @site.assets['app.css']) }
      subject { file.destination @dest.to_s }
      it { should match %r{/app-[0-9a-f]{32}\.css$} }
    end
  end
end
