require 'spec_helper'
describe Dckerize::Extra do
  let(:elasticsearch_extra) {
    Dckerize::Extra.new('elasticsearch')
  }

  it 'should be possible to initialize with a name' do
    expect(elasticsearch_extra.name).to eq 'elasticsearch'
  end

  describe '#image' do
    it 'should return the correct image name' do
      expect(elasticsearch_extra.image).to eq 'elasticsearch'
    end
  end
end
