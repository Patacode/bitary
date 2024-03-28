# frozen_string_literal: true

require 'bitary/handler/set'

RSpec.describe Bitary::Handler::Set do
  describe '#execute' do
    it 'sets the bit at given index to 1 (starting from leftmost bit)' do
      bit_setter = Bitary::Handler::Set.new(128)

      expect(bit_setter.execute(index: 1, size: 8)).to eq(192)
    end

    it 'raises a KeyError if no index kwarg is provided' do
      bit_setter = Bitary::Handler::Set.new(128)

      expect { bit_setter.execute(size: 8) }.to raise_error(KeyError)
    end

    it 'raises a KeyError if no size kwarg is provided' do
      bit_setter = Bitary::Handler::Set.new(128)

      expect { bit_setter.execute(index: 8) }.to raise_error(KeyError)
    end

    it 'raises an ArgumentError if provided index is not an integer' do
      bit_setter = Bitary::Handler::Set.new(128)

      expect { bit_setter.execute(index: 'hello', size: 8) }.to raise_error(
        ArgumentError
      )
    end

    it 'raises an ArgumentError if provided size is not an integer' do
      bit_unsetter = Bitary::Handler::Set.new(128)

      expect { bit_unsetter.execute(index: 8, size: 'hello') }.to raise_error(
        ArgumentError
      )
    end

    it 'raises an IndexError if provided index is out of bounds' do
      bit_setter = Bitary::Handler::Set.new(128)

      expect { bit_setter.execute(index: -1, size: 8) }.to raise_error(
        IndexError
      )
      expect { bit_setter.execute(index: 8, size: 8) }.to raise_error(
        IndexError
      )
    end

    it(
      'raises an ArgumentError if other kwargs than index or size are provided'
    ) do
      bit_setter = Bitary::Handler::Set.new(128)

      expect do
        bit_setter.execute(index: 3, size: 8, unexpected: 'value')
      end.to raise_error(ArgumentError)
    end
  end
end
