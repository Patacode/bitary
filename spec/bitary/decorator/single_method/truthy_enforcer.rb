# frozen_string_literal: true

require 'bitary'

RSpec.describe Bitary::Decorator::TruthyEnforcer do
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
      deco = Bitary::Decorator::TruthyEnforcer.new(fake_class.new, :execute)

      expect(deco).to be_instance_of(Bitary::Decorator::TruthyEnforcer)
    end

    it 'raises an ArgumentError if given method is not a Symbol' do
      expect do
        Bitary::Decorator::TruthyEnforcer.new(fake_class.new, 'invalid')
      end.to raise_error(ArgumentError)
    end

    it "raises a NoMethodError if wrappee doesn't respond to given method" do
      expect do
        Bitary::Decorator::TruthyEnforcer.new(fake_class.new, :invalid)
      end.to raise_error(NoMethodError)
    end

    it 'raises an ArgumentError if more than 2 pos args are given' do
      expect do
        Bitary::Decorator::TruthyEnforcer.new(fake_class.new, :run, 1)
      end.to raise_error(ArgumentError)
    end

    it 'raises an ArgumentError if kwargs are given' do
      expect do
        Bitary::Decorator::TruthyEnforcer.new(fake_class.new, :run, a: 1)
      end.to raise_error(ArgumentError)
    end
  end

  describe 'wrappee instance method chosen by decorator' do
    before(:example) do
      @run_deco = Bitary::Decorator::TruthyEnforcer.new(fake_class.new, :run)
      @execute_deco =
        Bitary::Decorator::TruthyEnforcer.new(fake_class.new, :execute)
    end

    it "returns the method's original return value if truthy" do
      expect(@execute_deco.execute(a: 1)).to eq({ a: 1 })
    end

    it(
      "raises no error if method's original return value is falsy but chosen" \
      'method is a different one'
    ) do
      expect(@execute_deco.run(a: 1)).to be(false)
    end

    it "raises a TypeError if method's original return value is false" do
      expect { @run_deco.run(a: 1) }.to raise_error(TypeError)
    end
  end
end
