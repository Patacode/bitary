# frozen_string_literal: true

require 'bitary/handler/append'

RSpec.describe Bitary::Handler::Append do
  describe '#execute' do
    before(:example) do
      @bit_appender = Bitary::Handler::Append.new(128)
    end

    it 'gets the bit at given index (starting from leftmost bit)' do
      expect(@bit_appender.execute(value: 0b1111)).to eq(2_063)
    end

    it 'raises a KeyError if no value kwarg is provided' do
      expect { @bit_appender.execute }.to raise_error(KeyError)
    end

    it 'raises an ArgumentError if provided value is not an integer' do
      expect { @bit_appender.execute(value: 'hello') }.to raise_error(
        ArgumentError
      )
    end

    it(
      'raises an ArgumentError if other kwargs than value is provided'
    ) do
      expect do
        @bit_appender.execute(value: 0b1111, unexpected: 'value')
      end.to raise_error(ArgumentError)
    end
  end
end
