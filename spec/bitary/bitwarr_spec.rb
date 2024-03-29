# frozen_string_literal: true

require 'bitary/bitwarr'

RSpec.describe Bitary::Bitwarr do
  describe '::new' do
    it 'returns a new Bitwarr instance with given integer initial data' do
      bitwarr = Bitary::Bitwarr.new(128)

      expect(bitwarr).to be_instance_of(Bitary::Bitwarr)
    end

    it 'returns a new Bitwarr instance with given array initial data' do
      bitwarr = Bitary::Bitwarr.new([1, 2, 3])

      expect(bitwarr).to be_instance_of(Bitary::Bitwarr)
    end

    it 'returns a new Bitwarr instance with given init data and bpi' do
      bitwarr = Bitary::Bitwarr.new(128, bpi: 8)

      expect(bitwarr).to be_instance_of(Bitary::Bitwarr)
    end

    it 'raises an ArgumentError if init data is not Integer nor Array' do
      expect { Bitary::Bitwarr.new('hello') }.to raise_error(ArgumentError)
    end

    it 'raises an ArgumentError if given bpi is not Integer' do
      expect { Bitary::Bitwarr.new(128, bpi: 'hello') }.to raise_error(
        ArgumentError
      )
    end

    it 'raises an ArgumentError if no args are given' do
      expect { Bitary::Bitwarr.new }.to raise_error(ArgumentError)
    end

    it 'raises an ArgumentError if more than 1 pos arg is given' do
      expect { Bitary::Bitwarr.new(128, 4) }.to raise_error(ArgumentError)
    end

    it 'raises an ArgumentError other kwarg than bpi is given' do
      expect { Bitary::Bitwarr.new(128, unknown: 'kwarg') }.to raise_error(
        ArgumentError
      )
    end
  end

  describe "every Array's instance methods" do
    it 'acts as an array and responds to each of its supported methods' do
      bitwarr = Bitary::Bitwarr.new(128)
      array = []

      array.methods.each { |method| expect(bitwarr).to respond_to(method) }
    end
  end

  describe '#item_index' do
    it 'returns the index of the item at given bit index' do
      bitwarr = Bitary::Bitwarr.new([1, 2, 3], bpi: 8)

      expect(bitwarr.item_index(7)).to eq(0)
      expect(bitwarr.item_index(18)).to eq(2)
    end

    it 'raises an IndexError if given bit index is out of bounds' do
      bitwarr = Bitary::Bitwarr.new([1, 2, 3], bpi: 8)

      expect { bitwarr.item_index(-1) }.to raise_error(IndexError)
      expect { bitwarr.item_index(24) }.to raise_error(IndexError)
    end

    it 'raises an ArgumentError if given pos arg is not Integer' do
      bitwarr = Bitary::Bitwarr.new([1, 2, 3], bpi: 8)

      expect { bitwarr.item_index('tt') }.to raise_error(ArgumentError)
    end

    it 'raises an ArgumentError if more than 1 pos arg is given' do
      bitwarr = Bitary::Bitwarr.new([1, 2, 3], bpi: 8)

      expect { bitwarr.item_index(1, 2) }.to raise_error(ArgumentError)
    end

    it 'raises an ArgumentError if kwargs are given' do
      bitwarr = Bitary::Bitwarr.new([1, 2, 3], bpi: 8)

      expect { bitwarr.item_index(1, a: 1) }.to raise_error(ArgumentError)
    end
  end

  describe '#bitsize' do
    it 'returns the bit size of the Bitwarr when built with explicit size' do
      bitwarr = Bitary::Bitwarr.new(128)

      expect(bitwarr.bitsize).to eq(128)
    end

    it 'returns the bit size of the Bitwarr when built from an array' do
      bitwarr = Bitary::Bitwarr.new([1, 2, 3])

      expect(bitwarr.bitsize).to eq(192)
    end

    it 'returns the bit size of the item at given bit index' do
      bitwarr = Bitary::Bitwarr.new(20, bpi: 8)

      expect(bitwarr.bitsize(12)).to eq(8)
      expect(bitwarr.bitsize(16)).to eq(4)
    end

    it 'raises an IndexError if item index is out of bounds' do
      bitwarr = Bitary::Bitwarr.new(20, bpi: 8)

      expect { bitwarr.bitsize(-1) }.to raise_error(IndexError)
      expect { bitwarr.bitsize(20) }.to raise_error(IndexError)
    end

    it 'raises an ArgumentError if item index is not Integer but nil' do
      bitwarr = Bitary::Bitwarr.new(20, bpi: 8)

      expect(bitwarr.bitsize(nil)).to eq(20)
      expect { bitwarr.bitsize('tt') }.to raise_error(ArgumentError)
    end

    it 'raises an ArgumentError if more than 1 pos arg is given' do
      bitwarr = Bitary::Bitwarr.new(20, bpi: 8)

      expect { bitwarr.bitsize(1, 2) }.to raise_error(ArgumentError)
    end

    it 'raises an ArgumentError if kwargs are given' do
      bitwarr = Bitary::Bitwarr.new(20, bpi: 8)

      expect { bitwarr.bitsize(1, a: 1) }.to raise_error(ArgumentError)
    end
  end

  describe '#bpi' do
    it 'returns the bits per item set at built time' do
      bitwarr = Bitary::Bitwarr.new(128, bpi: 8)

      expect(bitwarr.bpi).to eq(8)
    end

    it 'has a default value of 64' do
      bitwarr = Bitary::Bitwarr.new(128)

      expect(bitwarr.bpi).to eq(64)
    end

    it 'raises an ArgumentError if args are provided' do
      bitwarr = Bitary::Bitwarr.new(128)

      expect { bitwarr.bpi('tt') }.to raise_error(ArgumentError)
      expect { bitwarr.bpi(a: 1) }.to raise_error(ArgumentError)
    end
  end

  describe '#bpi=' do
    it 'sets the bits per item to the new given integer value' do
      bitwarr = Bitary::Bitwarr.new(128, bpi: 8)

      bitwarr.bpi = 64

      expect(bitwarr.bpi).to eq(64)
    end


    it 'raises an ArgumentError if given arg is not Integer' do
      bitwarr = Bitary::Bitwarr.new(128)

      expect { bitwarr.bpi = 'hello' }.to raise_error(ArgumentError)
    end
  end

  describe '#[]' do
    it 'returns the item at given bit index' do
      bitwarr = Bitary::Bitwarr.new([1, 2, 3], bpi: 8)

      expect(bitwarr[7]).to eq(1)
      expect(bitwarr[16]).to eq(3)
    end

    it 'raises an IndexError if given bit index is < 0 or >= bit size' do
      bitwarr = Bitary::Bitwarr.new([1, 2, 3], bpi: 8)

      expect { bitwarr[-1] }.to raise_error(IndexError)
      expect { bitwarr[24] }.to raise_error(IndexError)
    end

    it 'raises an ArgumentError if given bit index is not Integer' do
      bitwarr = Bitary::Bitwarr.new([1, 2, 3], bpi: 8)

      expect { bitwarr['test'] }.to raise_error(ArgumentError)
    end

    it 'raises an ArgumentError if more than 1 pos arg is given' do
      bitwarr = Bitary::Bitwarr.new([1, 2, 3], bpi: 8)

      expect { bitwarr[1, 2] }.to raise_error(ArgumentError)
    end
  end

  describe '#[]=' do
    it 'sets the item at given bit index' do
      bitwarr = Bitary::Bitwarr.new([1, 2, 3], bpi: 8)

      bitwarr[7] = 10
      bitwarr[16] = 12

      expect(bitwarr[7]).to eq(10)
      expect(bitwarr[16]).to eq(12)
    end

    it 'raises an IndexError if given bit index is < 0 or >= bit size' do
      bitwarr = Bitary::Bitwarr.new([1, 2, 3], bpi: 8)

      expect { bitwarr[-1] = 10 }.to raise_error(IndexError)
      expect { bitwarr[24] = 10 }.to raise_error(IndexError)
    end

    it 'raises an ArgumentError if given bit index is not Integer' do
      bitwarr = Bitary::Bitwarr.new([1, 2, 3], bpi: 8)

      expect { bitwarr['test'] = 10 }.to raise_error(ArgumentError)
    end

    it 'raises an ArgumentError if more than 1 index pos arg is given' do
      bitwarr = Bitary::Bitwarr.new([1, 2, 3], bpi: 8)

      expect { bitwarr[1, 2] = 10 }.to raise_error(ArgumentError)
    end

    it 'raises an ArgumentError if given value is not Integer' do
      bitwarr = Bitary::Bitwarr.new([1, 2, 3], bpi: 8)

      expect { bitwarr[1] = 'test' }.to raise_error(ArgumentError)
    end
  end

  describe '#relative_bitindex' do
    it 'returns the relative bit index given an item index' do
      bitwarr = Bitary::Bitwarr.new([1, 2, 3], bpi: 8)

      expect(bitwarr.relative_bitindex(12)).to eq(4)
      expect(bitwarr.relative_bitindex(22)).to eq(6)
    end

    it 'raises an IndexError if given bit index is out of bounds' do
      bitwarr = Bitary::Bitwarr.new([1, 2, 3], bpi: 8)
      
      expect { bitwarr.relative_bitindex(-1) }.to raise_error(IndexError)
      expect { bitwarr.relative_bitindex(24) }.to raise_error(IndexError)
    end

    it 'raises an ArgumentError if given bit index is not Integer' do
      bitwarr = Bitary::Bitwarr.new([1, 2, 3], bpi: 8)

      expect { bitwarr.relative_bitindex('tt') }.to raise_error(ArgumentError)
    end

    it 'raises an ArgumentError if more than 1 pos arg is given' do
      bitwarr = Bitary::Bitwarr.new([1, 2, 3], bpi: 8)

      expect { bitwarr.relative_bitindex(1, 2) }.to raise_error(ArgumentError)
    end

    it 'raises an ArgumentError if more than kwargs are given' do
      bitwarr = Bitary::Bitwarr.new([1, 2, 3], bpi: 8)

      expect { bitwarr.relative_bitindex(1, a: 1) }.to raise_error(
        ArgumentError
      )
    end
  end
end
