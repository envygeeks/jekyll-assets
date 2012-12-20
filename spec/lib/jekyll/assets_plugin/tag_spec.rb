require 'spec_helper'


module Jekyll::AssetsPlugin
  describe Tag do
    let(:context) { { :registers => { :site => @site } } }

    def render content
      Liquid::Template.parse(content).render({}, context)
    end

    context '{% stylesheet <file> %}' do
      let(:tag_re) do
        %r{^#{Tag::STYLESHEET % ['/assets/app-[a-f0-9]{32}\.css']}$}
      end

      context 'when <file> is bundled' do
        subject { render('{% stylesheet app.css %}') }
        it { should match tag_re }
      end

      context 'when <file> extension is omited' do
        subject { render('{% stylesheet app %}') }
        it { should match tag_re }
      end

      context 'when <file> is not found' do
        subject { render('{% stylesheet not-found.css %}') }
        it { should be_empty }
      end

      context 'when <file> is not bundled' do
        subject { render('{% stylesheet vapor.css %}') }
        it { should be_empty }
      end
    end

    context '{% javasript <file> %}' do
      let(:tag_re) do
        %r{^#{Tag::JAVASCRIPT % ['/assets/app-[a-f0-9]{32}\.js']}$}
      end

      context 'when <file> is bundled' do
        subject { render('{% javascript app.js %}') }
        it { should match tag_re }
      end

      context 'when <file> extension omited' do
        subject { render('{% javascript app %}') }
        it { should match tag_re }
      end

      context 'when <file> is not found' do
        subject { render('{% javascript not-found.js %}') }
        it { should be_empty }
      end

      context 'when <file> is not bundled' do
        subject { render('{% javascript vapor.js %}') }
        it { should be_empty }
      end
    end

    context '{% asset_path <file.ext> %}' do
      context 'when <file> is bundled' do
        subject { render('{% asset_path app.css %}') }
        it { should match(%r{^/assets/app-[a-f0-9]{32}\.css$}) }
      end

      context 'when <file> is not found' do
        subject { render('{% asset_path not-found.js %}') }
        it { should be_empty }
      end

      context 'when <file> is not bundled' do
        subject { render('{% asset_path vapor.js %}') }
        it { should be_empty }
      end

      context 'with baseurl given as /foobar/' do
        before { context[:registers][:site].assets_config.baseurl = '/foobar/' }
        subject { render('{% asset_path app.css %}') }
        it { should match(%r{^/foobar/app-[a-f0-9]{32}\.css$}) }
      end
    end

    context '{% asset <file.ext> %}' do
      context 'when <file> exists' do
        subject { render('{% asset app.css %}') }
        it { should match(/body \{ background-image: url\(.+?\) \}/) }
      end

      context 'when <file> is not found' do
        subject { render('{% asset_path not-found.js %}') }
        it { should be_empty }
      end
    end
  end
end
