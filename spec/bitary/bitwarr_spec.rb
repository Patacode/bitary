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

  describe '#bitsize' do
    it 'returns the bit size of the Bitwarr when built with explicit size' do
      bitwarr = Bitary::Bitwarr.new(128)

      expect(bitwarr.bitsize).to eq(128)
    end

    it 'returns the bit size of the Bitwarr when built from an array' do
      bitwarr = Bitary::Bitwarr.new([1, 2, 3])

      expect(bitwarr.bitsize).to eq(192)
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

  describe '#[]' do
    it 'returns the item at given bit index' do
      bitwarr = Bitary::Bitwarr.new([1, 2, 3], bpi: 8)

      expect(bitwarr[7]).to eq(1)
      expect(bitwarr[16]).to eq(3)
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
  end

  describe '#bit_at' do
    let(:arr) do
      Bitary::Bitwarr.new([1, 2, 3], bpi: 8)
    end

    it 'gets the bit at given bit index' do
      expect(arr.bit_at(14)).to eq(1)
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
  end

  describe '#unbit_at!' do
    before(:example) do
      @arr = Bitary::Bitwarr.new([1, 2, 3], bpi: 8)
    end

    it 'unsets the bit at given bit index' do
      @arr.unbit_at!(14)

      expect(@arr.bit_at(14)).to eq(0)
    end
  end

  describe '#each_byte' do
    let(:arr) do
      Bitary::Bitwarr.new([1, 2, 3], bpi: 16)
    end

    it "iterates over each internal array's byte" do
      it = 0
      arr.each_byte do |byte|
        case it
        when 0 then expect(byte).to eq(1)
        when 1 then expect(byte).to eq(2)
        when 2 then expect(byte).to eq(3)
        when 3 then expect(byte).to eq(0)
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
      expect(arr.to_s).to eq('0000000100000010 0000001100000000')
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
      expect(arr.to_a).to eq([258, 772, 1_280])

      arr.bpi = 32
      expect(arr.to_a).to eq([16_909_060, 83_886_080])

      arr.bpi = 64
      expect(arr.to_a).to eq([72_623_859_789_987_840])
    end

    it 'decreases the bit size of each item to desired bit size from 64' do
      arr = Bitary::Bitwarr.new([1, 2, 3, 4, 5], bpi: 64)

      arr.bpi = 32
      expect(arr.to_a).to eq([16_909_060, 83_886_080])

      arr.bpi = 16
      expect(arr.to_a).to eq([258, 772, 1_280, 0])

      arr.bpi = 8
      expect(arr.to_a).to eq([1, 2, 3, 4, 5, 0, 0, 0])
    end
  end
end
