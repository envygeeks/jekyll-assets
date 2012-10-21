require 'spec_helper'


module Jekyll::AssetsPlugin
  describe Generator do
    it 'should output bundled files only' do
      files = []
      @dest.join('assets').each_child(false, &files.method(:push))
      files.map(&:to_s).should have(3).thing
    end
  end
end
