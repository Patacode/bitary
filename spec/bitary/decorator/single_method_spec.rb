# frozen_string_literal: true

require 'bitary'

RSpec.describe Bitary::Decorator::SingleMethod do
  let(:fake_class) do
    Class.new do
      def execute(**kwargs)
        kwargs
      end

      def run(**_kwargs)
        false
      end
    end
  end

  describe '::new' do
    it 'returns a new instance with given wrappee and method' do
      deco = Bitary::Decorator::SingleMethod.new(fake_class.new, :execute)

      expect(deco).to be_instance_of(Bitary::Decorator::SingleMethod)
    end

    it 'raises an ArgumentError if given method is not a Symbol' do
      expect do
        Bitary::Decorator::SingleMethod.new(fake_class.new, 'invalid')
      end.to raise_error(ArgumentError)
    end

    it "raises a NoMethodError if wrappee doesn't respond to given method" do
      expect do
        Bitary::Decorator::SingleMethod.new(fake_class.new, :invalid)
      end.to raise_error(NoMethodError)
    end

    it 'raises an ArgumentError if more than 2 pos args are given' do
      expect do
        Bitary::Decorator::SingleMethod.new(fake_class.new, :run, 1)
      end.to raise_error(ArgumentError)
    end

    it 'raises an ArgumentError if kwargs are given' do
      expect do
        Bitary::Decorator::SingleMethod.new(fake_class.new, :run, a: 1)
      end.to raise_error(ArgumentError)
    end
  end
end
