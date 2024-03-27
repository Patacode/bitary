# frozen_string_literal: true

require 'bitary/handler/set'

RSpec.describe Bitary::Handler::Set do
  describe '#execute' do
    it 'sets the bit at given index to 1 (starting from leftmost bit)' do
      bit_setter = Bitary::Handler::Set.new(128)

      expect(bit_setter.execute(index: 1)).to eq(192)
    end

    it 'raises an IndexError if provided index is out of bounds' do
      bit_setter = Bitary::Handler::Set.new(128)

      expect { bit_setter.execute(index: -1) }.to raise_error(IndexError)
      expect { bit_setter.execute(index: 8) }.to raise_error(IndexError)
    end
  end
end
