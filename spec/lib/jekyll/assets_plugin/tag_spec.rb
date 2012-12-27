require 'spec_helper'


module Jekyll::AssetsPlugin
  describe Tag do
    let(:context) { { :registers => { :site => @site } } }

    def render content
      Liquid::Template.parse(content).render({}, context)
    end

    context '{% stylesheet <file> %}' do
      def tag_re name
        file = "/assets/#{name}-[a-f0-9]{32}\.css"
        Regexp.new "^#{Tag::STYLESHEET % file}$"
      end

      context 'when <file> is bundled' do
        subject { render('{% stylesheet app.css %}') }
        it { should match tag_re("app") }
      end

      context 'when <file> is not explicitly bundled' do
        subject { render('{% stylesheet vapor.css %}') }
        it { should match tag_re("vapor") }
      end

      context 'when <file> extension is omited' do
        subject { render('{% stylesheet app %}') }
        it { should match tag_re("app") }
      end

      context 'when <file> is not found' do
        subject { render('{% stylesheet not-found.css %}') }
        it { should match "Liquid error: couldn't find file 'not-found.css'" }
      end
    end

    context '{% javascript <file> %}' do
      def tag_re name
        file = "/assets/#{name}-[a-f0-9]{32}\.js"
        Regexp.new "^#{Tag::JAVASCRIPT % file}$"
      end

      context 'when <file> is bundled' do
        subject { render('{% javascript app.js %}') }
        it { should match tag_re("app") }
      end

      context 'when <file> is not explicitly bundled' do
        subject { render('{% javascript vapor.js %}') }
        it { should match tag_re("vapor") }
      end

      context 'when <file> extension omited' do
        subject { render('{% javascript app %}') }
        it { should match tag_re("app") }
      end

      context 'when <file> is not found' do
        subject { render('{% javascript not-found.js %}') }
        it { should match "Liquid error: couldn't find file 'not-found.js'" }
      end
    end

    context '{% asset_path <file.ext> %}' do
      context 'when <file> is bundled' do
        subject { render('{% asset_path app.css %}') }
        it { should match(%r{^/assets/app-[a-f0-9]{32}\.css$}) }
      end

      context 'when <file> is not explicitly bundled' do
        subject { render('{% asset_path vapor.js %}') }
        it { should match(%r{^/assets/vapor-[a-f0-9]{32}\.js$}) }

        it "should bundle file automagically" do
          context[:registers][:site].cleanup
          context[:registers][:site].write

          File.exist?("#{fixtures_path.join '_site'}#{subject}").should be_true
        end
      end

      context 'when <file> is not found' do
        subject { render('{% asset_path not-found.js %}') }
        it { should match "Liquid error: couldn't find file 'not-found.js'" }
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
        it { should match "Liquid error: couldn't find file 'not-found.js'" }
      end
    end
  end
end
