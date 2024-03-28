# frozen_string_literal: true

require 'bitary/handler/unset'

RSpec.describe Bitary::Handler::Unset do
  describe '#execute' do
    it 'unsets the bit at given index to 0 (starting from leftmost bit)' do
      bit_unsetter = Bitary::Handler::Unset.new(128)

      expect(bit_unsetter.execute(index: 0)).to eq(0)
    end

    it 'raises an IndexError if provided index is out of bounds' do
      bit_unsetter = Bitary::Handler::Unset.new(128)

      expect { bit_unsetter.execute(index: -1) }.to raise_error(IndexError)
      expect { bit_unsetter.execute(index: 8) }.to raise_error(IndexError)
    end

    it 'raises an ArgumentError if provided index is not an integer' do
      bit_unsetter = Bitary::Handler::Unset.new(128)

      expect { bit_unsetter.execute(index: 'hello') }.to raise_error(
        ArgumentError
      )
    end

    it 'raises a KeyError if no index kwarg is provided' do
      bit_unsetter = Bitary::Handler::Unset.new(128)

      expect { bit_unsetter.execute }.to raise_error(KeyError)
    end

    it 'raises an ArgumentError if other kwargs than index are provided' do
      bit_unsetter = Bitary::Handler::Unset.new(128)

      expect do
        bit_unsetter.execute(index: 3, unexpected: 'value')
      end.to raise_error(ArgumentError)
    end
  end
end
