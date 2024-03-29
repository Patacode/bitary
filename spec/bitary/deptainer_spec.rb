# frozen_string_literal: true

require 'bitary/deptainer'

RSpec.shared_context :deptainer do
  before(:example) do
    @container = Bitary::Deptainer.new
  end
end

RSpec.describe Bitary::Deptainer do
  describe '::new' do
    it 'returns a new Deptainer instance wiht no args' do
      expect(Bitary::Deptainer.new).to be_instance_of(Bitary::Deptainer)
    end

    it 'raises an ArgumentError if args of any type are provided' do
      expect { Bitary::Deptainer.new(1) }.to raise_error(ArgumentError)
      expect { Bitary::Deptainer.new(a: 1) }.to raise_error(ArgumentError)
    end
  end

  describe '#[]= and #[]' do
    include_context :deptainer

    it 'returns the value of a previously added dependency' do
      @container[:dep] = 55

      expect(@container[:dep]).to eq(55)
    end
  end

  describe '#[]' do
    include_context :deptainer

    it 'returns nil if provided key does not exist' do
      expect(@container[:unknown]).to eq(nil)
    end

    it 'raises an ArgumentError if provided key is not a Symbol' do
      expect { @container['wrong'] }.to raise_error(ArgumentError)
    end
  end

  describe '#[]=' do
    include_context :deptainer

    it 'adds a dependency to the internal Deptainer store' do
      @container[:dep] = 55

      expect(@container[:dep]).to eq(55)
    end

    it 'overrides a dependency if some previously defined key is used' do
      @container[:dep] = 55
      @container[:dep] = 'hello'

      expect(@container[:dep]).to eq('hello')
    end

    it 'raises an ArgumentError if provided key is not a Symbol' do
      expect { @container['wrong'] = 55 }.to raise_error(ArgumentError)
    end
  end
end
