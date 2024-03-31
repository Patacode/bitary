# frozen_string_literal: true

require 'bitary'

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

    it 'raises an ArgumentError if bpi not in [8, 16, 32, 64]' do
      expect { Bitary::Bitwarr.new(128, bpi: 1) }.to raise_error(ArgumentError)
      expect { Bitary::Bitwarr.new(128, bpi: 12) }.to raise_error(ArgumentError)
      expect { Bitary::Bitwarr.new(128, bpi: 23) }.to raise_error(ArgumentError)
      expect { Bitary::Bitwarr.new(128, bpi: 54) }.to raise_error(ArgumentError)
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

  describe '#relative_bit_index' do
    it 'returns the relative bit index given an item index' do
      bitwarr = Bitary::Bitwarr.new([1, 2, 3], bpi: 8)

      expect(bitwarr.relative_bit_index(12)).to eq(4)
      expect(bitwarr.relative_bit_index(22)).to eq(6)
    end

    it 'raises an IndexError if given bit index is out of bounds' do
      bitwarr = Bitary::Bitwarr.new([1, 2, 3], bpi: 8)

      expect { bitwarr.relative_bit_index(-1) }.to raise_error(IndexError)
      expect { bitwarr.relative_bit_index(24) }.to raise_error(IndexError)
    end

    it 'raises an ArgumentError if given bit index is not Integer' do
      bitwarr = Bitary::Bitwarr.new([1, 2, 3], bpi: 8)

      expect { bitwarr.relative_bit_index('tt') }.to raise_error(ArgumentError)
    end

    it 'raises an ArgumentError if more than 1 pos arg is given' do
      bitwarr = Bitary::Bitwarr.new([1, 2, 3], bpi: 8)

      expect { bitwarr.relative_bit_index(1, 2) }.to raise_error(ArgumentError)
    end

    it 'raises an ArgumentError if more than kwargs are given' do
      bitwarr = Bitary::Bitwarr.new([1, 2, 3], bpi: 8)

      expect { bitwarr.relative_bit_index(1, a: 1) }.to raise_error(
        ArgumentError
      )
    end
  end

  describe '#bit_at' do
    let(:arr) do
      Bitary::Bitwarr.new([1, 2, 3], bpi: 8)
    end

    it 'gets the bit at given bit index' do
      expect(arr.bit_at(14)).to eq(1)
    end

    it 'raises an IndexError if given bit index is out of bounds' do
      expect { arr.bit_at(-1) }.to raise_error(IndexError)
      expect { arr.bit_at(24) }.to raise_error(IndexError)
    end

    it 'raises an ArgumentError if given bit index is not Integer' do
      expect { arr.bit_at('test') }.to raise_error(ArgumentError)
    end

    it 'raises an ArgumentError if more than 1 pos arg is given' do
      expect { arr.bit_at(1, 2) }.to raise_error(ArgumentError)
    end

    it 'raises an ArgumentError if kwargs are given' do
      expect { arr.bit_at(1, a: 1) }.to raise_error(ArgumentError)
    end
  end

  describe '#bit_at!' do
    before(:example) do
      @arr = Bitary::Bitwarr.new([1, 2, 3], bpi: 8)
    end

    it 'sets the bit at given bit index' do
      @arr.bit_at!(13)

      expect(@arr.bit_at(13)).to eq(1)
    end

    it 'raises an IndexError if given bit index is out of bounds' do
      expect { @arr.bit_at!(-1) }.to raise_error(IndexError)
      expect { @arr.bit_at!(24) }.to raise_error(IndexError)
    end

    it 'raises an ArgumentError if given bit index is not Integer' do
      expect { @arr.bit_at!('test') }.to raise_error(ArgumentError)
    end

    it 'raises an ArgumentError if more than 1 pos arg is given' do
      expect { @arr.bit_at!(1, 2) }.to raise_error(ArgumentError)
    end

    it 'raises an ArgumentError if kwargs are given' do
      expect { @arr.bit_at!(1, a: 1) }.to raise_error(ArgumentError)
    end
  end

  describe '#unbit_at!' do
    before(:example) do
      @arr = Bitary::Bitwarr.new([1, 2, 3], bpi: 8)
    end

    it 'unsets the bit at given bit index' do
      @arr.unbit_at!(14)

      expect(@arr.bit_at(14)).to eq(0)
    end

    it 'raises an IndexError if given bit index is out of bounds' do
      expect { @arr.unbit_at!(-1) }.to raise_error(IndexError)
      expect { @arr.unbit_at!(24) }.to raise_error(IndexError)
    end

    it 'raises an ArgumentError if given bit index is not Integer' do
      expect { @arr.unbit_at!('test') }.to raise_error(ArgumentError)
    end

    it 'raises an ArgumentError if more than 1 pos arg is given' do
      expect { @arr.unbit_at!(1, 2) }.to raise_error(ArgumentError)
    end

    it 'raises an ArgumentError if kwargs are given' do
      expect { @arr.unbit_at!(1, a: 1) }.to raise_error(ArgumentError)
    end
  end

  describe '#each_byte' do
    let(:arr) do
      Bitary::Bitwarr.new([1, 2, 3], bpi: 16)
    end

    it "iterates over each internal array's byte" do
      it = 0
      arr.each_byte do |byte|
        if (it & 0x1) == 0
          expect(byte).to eq(0)
        else
          case it
          when 1 then expect(byte).to eq(1)
          when 3 then expect(byte).to eq(2)
          when 5 then expect(byte).to eq(3)
          end
        end

        it += 1
      end
    end

    it 'raises an ArgumentError if pos args are given' do
      expect { arr.each_byte(1) }.to raise_error(ArgumentError)
    end

    it 'raises an ArgumentError if kwargs are given' do
      expect { arr.each_byte(a: 1) }.to raise_error(ArgumentError)
    end
  end

  describe '#to_s' do
    let(:arr) do
      Bitary::Bitwarr.new([1, 2, 3], bpi: 16)
    end

    it 'converts the internal array to a binary string' do
      expect(arr.to_s).to eq(
        '0000000000000001 0000000000000010 0000000000000011'
      )
    end

    it 'raises an ArgumentError if pos args are given' do
      expect { arr.to_s(1) }.to raise_error(ArgumentError)
    end

    it 'raises an ArgumentError if kwargs are given' do
      expect { arr.to_s(a: 1) }.to raise_error(ArgumentError)
    end
  end

  describe '#bpi=' do
    it 'increases the bit size of each item to desired bit size from 8' do
      arr = Bitary::Bitwarr.new([1, 2, 3, 4, 5], bpi: 8)

      arr.bpi = 16
      expect(arr.to_a).to eq([258, 772, 5])

      arr.bpi = 32
      expect(arr.to_a).to eq([16_909_060, 5])

      arr.bpi = 64
      expect(arr.to_a).to eq([72_623_859_706_101_765])
    end

    it 'increases the bit size of each item to desired bit size from 16' do
      arr = Bitary::Bitwarr.new([1, 2, 3, 4, 5], bpi: 16)

      arr.bpi = 32
      expect(arr.to_a).to eq([65_538, 196_612, 5])

      arr.bpi = 64
      expect(arr.to_a).to eq([281_483_566_841_860, 5])
    end

    it 'increases the bit size of each item to desired bit size from 32' do
      arr = Bitary::Bitwarr.new([1, 2, 3, 4, 5], bpi: 32)

      arr.bpi = 64
      expect(arr.to_a).to eq([4_294_967_298, 12_884_901_892, 5])
    end

    it 'decreases the bit size of each item to desired bit size from 64' do
      arr = Bitary::Bitwarr.new([4_294_967_298, 12_884_901_892, 5], bpi: 64)

      arr.bpi = 32
      expect(arr.to_a).to eq([1, 2, 3, 4, 0, 5])

      arr.bpi = 16
      expect(arr.to_a).to eq([0, 1, 0, 2, 0, 3, 0, 4, 0, 0, 0, 5])

      arr.bpi = 8
      expect(arr.to_a).to eq(
        [0, 0, 0, 1, 0, 0, 0, 2, 0, 0, 0, 3, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 5]
      )
    end

    it 'decreases the bit size of each item to desired bit size from 32' do
      arr = Bitary::Bitwarr.new([65_538, 196_612, 5], bpi: 32)

      arr.bpi = 16
      expect(arr.to_a).to eq([1, 2, 3, 4, 0, 5])

      arr.bpi = 8
      expect(arr.to_a).to eq([0, 1, 0, 2, 0, 3, 0, 4, 0, 0, 0, 5])
    end

    it 'decreases the bit size of each item to desired bit size from 16' do
      arr = Bitary::Bitwarr.new([258, 772, 5], bpi: 16)

      arr.bpi = 8
      expect(arr.to_a).to eq([1, 2, 3, 4, 0, 5])
    end

    it 'raises an ArgumentError if given bit size is not in [8, 16, 32, 64]' do
      arr = Bitary::Bitwarr.new([258, 772, 5], bpi: 16)

      expect { arr.bpi = 9 }.to raise_error(ArgumentError)
      expect { arr.bpi = 15 }.to raise_error(ArgumentError)
      expect { arr.bpi = 31 }.to raise_error(ArgumentError)
      expect { arr.bpi = 63 }.to raise_error(ArgumentError)
      expect { arr.bpi = 'test' }.to raise_error(ArgumentError)
    end
  end
end
