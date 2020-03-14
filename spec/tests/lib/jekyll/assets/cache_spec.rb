# Frozen-string-literal: true
# Copyright: 2012 - 2020 - ISC License
# Encoding: utf-8

require 'rspec/helper'
describe Jekyll::Assets::Cache do
  def args(**kwd)
    {
      manifest: env.manifest,
      config: env.asset_config,
      dir: env.in_cache_dir,
      **kwd,
    }
  end

  it { respond_to(:set) }
  it { respond_to(:fetch) }
  it { respond_to(:clear) }
  it { respond_to(:get) }

  describe '#initialize' do
    context 'with an invalid dir' do
      subject do
        described_class.new(**args({
          dir: 'bad'
        }))
      end

      it 'must raise' do
        err = described_class::RelativeCacheDir
        expect { subject }.to raise_error(
          err
        )
      end
    end

    context 'with a new manifest' do
      subject do
        described_class.new(
          args
        )
      end

      before do
        method = :new_manifest?
        allow(env.manifest).to receive(method).and_return(
          true
        )
      end

      it 'must clear' do
        klass = described_class::Upstream
        expect_any_instance_of(klass).to receive(
          :clear
        )
      end

      after do
        subject.send(
          :instance
        )
      end
    end
  end
end
