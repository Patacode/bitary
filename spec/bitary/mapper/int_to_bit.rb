# frozen_string_literal: true

require 'bitary'

RSpec.describe Bitary::Mapper::IntToBit do
  describe '#map' do
    let(:mapper) do
      Bitary::Mapper::IntToBit.new
    end

    it 'returns 1 if given value is not an Integer' do
      expect(mapper.map('test')).to eq(1)
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
