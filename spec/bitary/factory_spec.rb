# frozen_string_literal: true

require 'bitary/factory'

class Bitary
  class Nest
    class FakeClass
      def initialize(one = nil, two: nil)
        @one = one
        @two = two
      end
    end
  end
end

RSpec.describe Bitary::Factory do
  describe '::new' do
    it 'raises a NoMethodError exception when called' do
      expect { Bitary::Factory.new }.to raise_error(NoMethodError)
    end
  end

  describe '::make' do
    it 'returns a new fresh instance of the provided class string'do
      instance = Bitary::Factory.make('Nest::FakeClass')

      expect(instance).to be_instance_of(Bitary::Nest::FakeClass)
    end

    it 'returns also a new fresh instance when further called' do
      instance1 = Bitary::Factory.make('Nest::FakeClass')
      instance2 = Bitary::Factory.make('Nest::FakeClass')

      expect(instance1).not_to be(instance2)
    end

    it 'passes the additional pos args and kwargs to returned instance' do
      instance = Bitary::Factory.make('Nest::FakeClass', 55, two: 32)

      expect(instance).to be_instance_of(Bitary::Nest::FakeClass)
    end

    it 'raises an ArgumentError if no args is passed' do
      expect { Bitary::Factory.make }.to raise_error(ArgumentError)
    end

    it 'raises an ArgumentError if first pos arg is not a string' do
      expect { Bitary::Factory.make(23) }.to raise_error(ArgumentError)
    end

    it 'raises a NameError if provided class string refer to inexistent cls' do
      expect { Bitary::Factory.make('Unknown') }.to raise_error(NameError)
    end
  end

  describe '::make_memo' do
    it(
      'returns a new fresh instance of the provided class string the first ' \
      'time it is called'
    ) do
      instance = Bitary::Factory.make_memo('Nest::FakeClass', 55, two: 32)

      expect(instance).to be_instance_of(Bitary::Nest::FakeClass)
    end

    it 'returns the memoized instance when further called' do
      instance1 = Bitary::Factory.make_memo('Nest::FakeClass')
      instance2 = Bitary::Factory.make_memo('Nest::FakeClass')

      expect(instance1).to be(instance2)
    end

    it(
      'raises an ArgumentError if more than 1 pos arg and/or kwargs are ' \
      'passed when further called'
    ) do
      expect do
        Bitary::Factory.make_memo('Nest::FakeClass', 66, two: 34)
      end.to raise_error(ArgumentError)
    end

    it 'raises an ArgumentError if no args is passed' do
      expect { Bitary::Factory.make_memo }.to raise_error(ArgumentError)
    end

    it 'raises an ArgumentError if first pos arg is not a string' do
      expect { Bitary::Factory.make_memo(23) }.to raise_error(ArgumentError)
    end

    it 'raises a NameError if provided class string refer to inexistent cls' do
      expect { Bitary::Factory.make_memo('Unknown') }.to raise_error(NameError)
    end
  end
end
