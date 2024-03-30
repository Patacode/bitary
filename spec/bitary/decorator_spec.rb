# frozen_string_literal: true

require 'bitary/decorator'

RSpec.describe Bitary::Decorator do
  let(:fake_class) do
    Class.new do
      def execute(**kwargs)
        kwargs
      end

      def run(**kwargs)
        kwargs
      end
    end
  end

  describe '::new' do
    it 'returns a new Decorator instance with given wrappee' do
      deco = Bitary::Decorator.new(fake_class.new)

      expect(deco).to be_instance_of(Bitary::Decorator)
    end

    it 'returns a new Decorator instance with given wrappee and predicate' do
      deco = Bitary::Decorator.new(fake_class.new) do |method|
        method == :execute
      end

      expect(deco).to be_instance_of(Bitary::Decorator)
    end

    it 'raises an ArgumentError if no args are given' do
      expect { Bitary::Decorator.new }.to raise_error(ArgumentError)
    end

    it 'raises an ArgumentError if more than 1 pos arg is given' do
      expect { Bitary::Decorator.new(fake_class.new, 2) }.to raise_error(
        ArgumentError
      )
    end

    it 'raises an ArgumentError if kwargs are given' do
      expect { Bitary::Decorator.new(fake_class.new, a: 1) }.to raise_error(
        ArgumentError
      )
    end
  end

  describe 'every wrappee instance methods' do
    it 'responds to the same methods that wrappee defines' do
      deco = Bitary::Decorator.new(fake_class.new)

      expect(deco).to respond_to(:execute)
      expect(deco).to respond_to(:run)
    end

    it 'does not respond to methods not defined by wrappee' do
      deco = Bitary::Decorator.new(fake_class.new)

      expect(deco).not_to respond_to(:unknown)
    end

    it 'does not modify the original wrappee implementation by default' do
      deco = Bitary::Decorator.new(fake_class.new)

      expect(deco.execute(a: 1, b: 2)).to eq({ a: 1, b: 2 })
    end

    it 'decorates methods matching the predicate' do
      deco = Bitary::Decorator.new(fake_class.new) do |method|
        method == :execute
      end

      allow(deco).to receive(:precall).with(:execute).and_return([[], {}])
      allow(deco).to receive(:postcall).with({}).and_return({})

      deco.execute

      expect(deco).to have_received(:precall).exactly(1).time
      expect(deco).to have_received(:postcall).exactly(1).time
    end

    it 'calls wrappee methods without alteration if do not match predicate' do
      deco = Bitary::Decorator.new(fake_class.new) do |method|
        method == :execute
      end

      allow(deco).to receive(:precall).exactly(0).time
      allow(deco).to receive(:postcall).exactly(0).time

      deco.run

      expect(deco).to have_received(:precall).exactly(0).time
      expect(deco).to have_received(:postcall).exactly(0).time
    end

    it 'raises an ArgumentError if unexpected args are given' do
      deco = Bitary::Decorator.new(fake_class.new)

      expect { deco.execute(1, a: 1, b: 2) }.to raise_error(ArgumentError)
    end
  end
end
