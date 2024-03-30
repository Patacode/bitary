# frozen_string_literal: true

require 'bitary'

RSpec.describe Bitary::Mapper do
  describe '::new' do
    it 'returns a new instance with no args/kwargs given' do
      mapper = Bitary::Mapper.new

      expect(mapper.wrappee).to be_instance_of(Bitary::Mapper)
    end

    it 'raises an ArgumentError if pos args are given' do
      expect { Bitary::Mapper.new(1) }.to raise_error(ArgumentError)
    end

    it 'raises an ArgumentError if kwargs are given' do
      expect { Bitary::Mapper.new(a: 1) }.to raise_error(ArgumentError)
    end
  end

  describe '#map' do
    let(:mapper) do
      Bitary::Mapper.new
    end

    it 'raises a NotImplementedError when called' do
      expect { mapper.map(1) }.to raise_error(NotImplementedError)
    end

    it 'raises an ArgumentError if more than 1 pos args are given' do
      expect { mapper.map(1, 2) }.to raise_error(ArgumentError)
    end

    it 'raises an ArgumentError if no args are given' do
      expect { mapper.map }.to raise_error(ArgumentError)
    end

    it 'raises an ArgumentError if kwargs are given' do
      expect { mapper.map(1, a: 1) }.to raise_error(ArgumentError)
    end
  end
end
