# Frozen-string-literal: true
# Copyright: 2012 - 2020 - ISC License
# Encoding: utf-8

require 'rspec/helper'
describe Jekyll::Assets::Config do
  it 'merges' do
    test = subject.new(hello: :world)
    test = test.values_at(
      :hello, :autowrite
    )

    expect(test).to eq(
      [
        :world,
        subject.development[
          :autowrite
        ]
      ]
    )
  end

  it 'merges sources' do
    regex = %r!hello!
    subject = self.subject.new(sources: ['hello'])
    expect(subject[:sources].grep(regex).size).to eq(
      1
    )
  end
end
