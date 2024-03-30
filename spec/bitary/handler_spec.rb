# frozen_string_literal: true

require 'bitary'

RSpec.describe Bitary::Handler do
  describe '::new' do
    it 'returns a new Handler instance with provided integer value' do
      expect(Bitary::Handler.new(10)).to be_instance_of(Bitary::Handler)
    end

    it 'raises an ArgumentError if provided value is not an integer' do
      expect { Bitary::Handler.new('hello') }.to raise_error(ArgumentError)
    end
  end

  describe '#execute' do
    it 'raises a NotImplementedError when called' do
      handler = Bitary::Handler.new(100)

      expect { handler.execute }.to raise_error(NotImplementedError)
    end

    it 'cannot be called with positional arguments' do
      handler = Bitary::Handler.new(100)

      expect { handler.execute(1) }.to raise_error(ArgumentError)
    end
  end

  describe '#value' do
    it 'returns the integer value provided in constructor' do
      handler = Bitary::Handler.new(100)

      expect(handler.value).to eq(100)
    end
  end
end
