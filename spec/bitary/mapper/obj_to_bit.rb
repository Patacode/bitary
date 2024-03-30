# frozen_string_literal: true

require 'bitary'

RSpec.describe Bitary::Mapper::ObjToBit do
  describe '#map' do
    let(:mapper) do
      Bitary::Mapper::ObjToBit.new
    end

    it 'returns 1 if given value is truthy' do
      expect(mapper.map([1, 2])).to eq(1)
    end

    it 'returns 0 if given value is falsy' do
      expect(mapper.map(false)).to eq(0)
    end

    it 'returns 1 if given value is an Integer > 0' do
      expect(mapper.map(32)).to eq(1)
    end

    it 'returns 1 if given value is an Integer < 0' do
      expect(mapper.map(-32)).to eq(1)
    end

    it 'returns 0 if given value is an Integer == 0' do
      expect(mapper.map(0)).to eq(0)
    end
  end
end
