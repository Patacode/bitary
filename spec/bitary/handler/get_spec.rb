# frozen_string_literal: true

require 'bitary/handler/get'

RSpec.describe Bitary::Handler::Get do
  describe '#execute' do
    before(:example) do
      @bit_getter = Bitary::Handler::Get.new(128)
    end

    it 'gets the bit at given index (starting from leftmost bit)' do
      expect(@bit_getter.execute(index: 0, size: 8)).to eq(1)
    end

    it 'raises a KeyError if no index kwarg is provided' do
      expect { @bit_getter.execute(size: 8) }.to raise_error(KeyError)
    end

    it 'raises a KeyError if no size kwarg is provided' do
      expect { @bit_getter.execute(index: 8) }.to raise_error(KeyError)
    end

    it 'raises an ArgumentError if provided index is not an integer' do
      expect { @bit_getter.execute(index: 'hello', size: 8) }.to raise_error(
        ArgumentError
      )
    end

    it 'raises an ArgumentError if provided size is not an integer' do
      expect { @bit_getter.execute(index: 8, size: 'hello') }.to raise_error(
        ArgumentError
      )
    end

    it 'raises an IndexError if provided index is out of bounds' do
      expect { @bit_getter.execute(index: -1, size: 8) }.to raise_error(
        IndexError
      )
      expect { @bit_getter.execute(index: 8, size: 8) }.to raise_error(
        IndexError
      )
    end

    it(
      'raises an ArgumentError if other kwargs than index or size are provided'
    ) do
      expect do
        @bit_getter.execute(index: 3, size: 8, unexpected: 'value')
      end.to raise_error(ArgumentError)
    end
  end
end