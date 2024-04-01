# frozen_string_literal: true

require 'bitary'

RSpec.shared_context :bitwarr do
  before(:example) do
    @bitwarr = Bitary::Bitwarr.new(bytes: [1, 2, 3], bpi: 8)
  end
end

RSpec.describe Bitary::Bitwarr do
  describe '::new' do
    include_examples :constructor, Bitary::Bitwarr
  end

  describe '#bitsize' do
    it 'returns the bit size given in constructor' do
      bitwarr = Bitary::Bitwarr.new(73)

      expect(bitwarr.bitsize).to eq(73)
    end

    it 'returns the bit size deducted from byte array given in constructor' do
      bitwarr = Bitary::Bitwarr.new(bytes: [1, 2, 3])

      expect(bitwarr.bitsize).to eq(24)
    end

    it(
      'returns a default value of 128 when it cannot be deducted from ' \
      'constructor args'
    ) do
      bitwarr = Bitary::Bitwarr.new

      expect(bitwarr.bitsize).to eq(128)
    end
  end

  describe '#bpi' do
    it 'returns the number of bits used per item given in constructor' do
      bitwarr = Bitary::Bitwarr.new(128, bpi: 8)

      expect(bitwarr.bpi).to eq(8)
    end

    it 'returns a default value of 64 when not given in constructor' do
      bitwarr = Bitary::Bitwarr.new

      expect(bitwarr.bpi).to eq(64)
    end
  end

  describe '#[]' do
    include_context :bitwarr

    it 'returns the item at given bit index' do
      expect(@bitwarr[7]).to eq(1)
      expect(@bitwarr[16]).to eq(3)
    end
  end

  describe '#[]=' do
    include_context :bitwarr

    it 'sets the item at given bit index' do
      @bitwarr[7] = 10
      @bitwarr[16] = 12

      expect(@bitwarr[7]).to eq(10)
      expect(@bitwarr[16]).to eq(12)
    end
  end

  describe '#bit_at' do
    include_context :bitwarr

    it 'gets the bit at given bit index' do
      expect(@bitwarr.bit_at(13)).to eq(0)
      expect(@bitwarr.bit_at(14)).to eq(1)
    end
  end

  describe '#bit_at!' do
    include_context :bitwarr

    it 'sets the bit at given bit index' do
      @bitwarr.bit_at!(13)

      expect(@bitwarr.bit_at(13)).to eq(1)
    end
  end

  describe '#unbit_at!' do
    include_context :bitwarr

    it 'unsets the bit at given bit index' do
      @bitwarr.unbit_at!(14)

      expect(@bitwarr.bit_at(14)).to eq(0)
    end
  end

  describe '#each_byte' do
    include_context :bitwarr

    it "iterates over each internal array's byte" do
      counter = 0
      @bitwarr.each_byte do |byte|
        case counter
        when 0 then expect(byte).to eq(1)
        when 1 then expect(byte).to eq(2)
        when 2 then expect(byte).to eq(3)
        end
        counter += 1
      end
    end
  end

  describe '#to_s' do
    include_context :bitwarr

    it 'converts the internal array to a binary string' do
      expect(@bitwarr.to_s).to eq('00000001 00000010 00000011')
    end
  end

  describe '#to_a' do
    it 'returns a shallow copy of internal array' do
      bitwarr = Bitary::Bitwarr.new(bytes: [1, 2, 3, 4, 5], bpi: 32)

      clone = bitwarr.to_a
      clone[0] = 33

      expect(bitwarr.to_a).to eq([16_909_060, 83_886_080])
    end
  end

  describe '#bpi=' do
    it 'increases the bits used per item' do
      bitwarr = Bitary::Bitwarr.new(bytes: [1, 2, 3, 4, 5], bpi: 8)

      bitwarr.bpi = 32

      expect(bitwarr.to_a).to eq([16_909_060, 83_886_080])
    end

    it 'decreases the bits used per item' do
      bitwarr = Bitary::Bitwarr.new(bytes: [1, 2, 3, 4, 5], bpi: 64)

      bitwarr.bpi = 16

      expect(bitwarr.to_a).to eq([258, 772, 1_280, 0])
    end
  end
end
