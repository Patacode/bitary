# frozen_string_literal: true

require 'bitary'

RSpec.shared_context :bitwarr do
  before(:example) do
    @bitwarr = Bitary::Bitwarr.new(nil, bytes: [1, 2, 3], bpi: 8)
  end
end

RSpec.describe Bitary::Bitwarr do
  describe '::new' do
    it(
      'returns a new instance with given byte array, initial bit capacity ' \
      'and bits per item'
    ) do
      instance = Bitary::Bitwarr.new(20, bytes: [1, 2, 3], bpi: 8)

      expect(instance).to be_instance_of(Bitary::Bitwarr)
    end
  end

  describe '#bits' do
    it 'returns the bit size given in constructor' do
      instance = Bitary::Bitwarr.new(73, bytes: nil, bpi: 8)

      expect(instance.bits).to eq(73)
    end

    it 'returns the bit size deducted from byte array given in constructor' do
      instance = Bitary::Bitwarr.new(nil, bytes: [1, 2, 3], bpi: 8)

      expect(instance.bits).to eq(24)
    end

    it(
      'returns a default value of 128 when it cannot be deducted from ' \
      'constructor args'
    ) do
      instance = Bitary::Bitwarr.new(nil, bytes: nil, bpi: 8)

      expect(instance.bits).to eq(128)
    end
  end

  describe '#to_a' do
    it 'returns a shallow copy of internal array' do
      instance = Bitary::Bitwarr.new(nil, bytes: [1, 2, 3, 4, 5], bpi: 32)

      clone = instance.to_a
      clone[0] = 33

      expect(instance.to_a).to eq([16_909_060, 83_886_080])
    end

    it(
      'returns an unchanged shallow copy of byte array given in constructor ' \
      'if bpi == 8'
    ) do
      instance = Bitary::Bitwarr.new(nil, bytes: [1, 2, 3, 4, 5], bpi: 8)

      clone = instance.to_a
      clone[0] = 33

      expect(instance.to_a).to eq([1, 2, 3, 4, 5])
    end

    it(
      'returns an unchanged shallow copy of byte array given in constructor ' \
      'if explicit size <= default'
    ) do
      instance = Bitary::Bitwarr.new(39, bytes: [1, 2, 3, 4, 5], bpi: 8)

      clone = instance.to_a
      clone[0] = 33

      expect(instance.to_a).to eq([1, 2, 3, 4, 5])
    end

    it(
      'returns an expanded shallow copy of byte array given in constructor ' \
      'if explicit size > default'
    ) do
      instance = Bitary::Bitwarr.new(33, bytes: [1, 2, 3], bpi: 16)

      clone = instance.to_a
      clone[0] = 33

      expect(instance.to_a).to eq([258, 768, 0])
    end
  end

  describe '#bpi' do
    it 'returns the number of bits used per item given in constructor' do
      instance = Bitary::Bitwarr.new(nil, bytes: nil, bpi: 8)

      expect(instance.bpi).to eq(8)
    end
  end

  describe '#bpi=' do
    it 'increases the bits used per item when value is > than actual bpi' do
      instance = Bitary::Bitwarr.new(nil, bytes: [1, 2, 3, 4, 5], bpi: 8)

      instance.bpi = 32

      expect(instance.to_a).to eq([16_909_060, 83_886_080])
    end

    it 'decreases the bits used per item when value is > than actual bpi' do
      instance = Bitary::Bitwarr.new(nil, bytes: [1, 2, 3, 4, 5], bpi: 64)

      instance.bpi = 16

      expect(instance.to_a).to eq([258, 772, 1_280, 0])
    end

    it 'does nothing if given value is == to actual bpi' do
      instance = Bitary::Bitwarr.new(nil, bytes: [1, 2, 3, 4, 5], bpi: 32)

      instance.bpi = 32

      expect(instance.to_a).to eq([16_909_060, 83_886_080])
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
    it 'gets the bit at given bit index when size is divisible by bpi' do
      instance = Bitary::Bitwarr.new(nil, bytes: [1, 2, 3], bpi: 8)

      expect(instance.bit_at(13)).to eq(0)
      expect(instance.bit_at(14)).to eq(1)
    end

    it 'gets the bit at given bit index when size is not divisible by bpi' do
      instance = Bitary::Bitwarr.new(27, bytes: [1, 2, 3], bpi: 8)

      expect(instance.bit_at(23)).to eq(1)
      expect(instance.bit_at(24)).to eq(0)
    end
  end

  describe '#bit_at!' do
    it(
      'sets the bit at given bit index when size is divisible by bpi and ' \
      'pre-init from byte array'
    ) do
      instance = Bitary::Bitwarr.new(nil, bytes: [1, 2, 3], bpi: 8)

      instance.bit_at!(13)

      expect(instance.bit_at(13)).to eq(1)
    end

    it(
      'sets the bit at given bit index when size is divisible by bpi and ' \
      'not pre-init from byte array'
    ) do
      instance = Bitary::Bitwarr.new(32, bytes: nil, bpi: 8)

      instance.bit_at!(23)

      expect(instance.bit_at(23)).to eq(1)
    end

    it(
      'sets the bit at given bit index when size is not divisible by bpi and ' \
      'pre-init from byte array'
    ) do
      instance = Bitary::Bitwarr.new(25, bytes: [1, 2, 3], bpi: 8)

      instance.bit_at!(24)

      expect(instance.bit_at(24)).to eq(1)
    end

    it(
      'sets the bit at given bit index when size is not divisible by bpi and ' \
      'not pre-init from byte array'
    ) do
      instance = Bitary::Bitwarr.new(35, bytes: nil, bpi: 8)

      instance.bit_at!(34)

      expect(instance.bit_at(34)).to eq(1)
    end
  end

  describe '#unbit_at!' do
    it(
      'unsets the bit at given bit index when size is divisible by bpi and ' \
      'pre-init from byte array'
    ) do
      instance = Bitary::Bitwarr.new(nil, bytes: [1, 2, 3], bpi: 8)

      instance.unbit_at!(14)

      expect(instance.bit_at(14)).to eq(0)
    end

    it(
      'unsets the bit at given bit index when size is divisible by bpi and ' \
      'not pre-init from byte array'
    ) do
      instance = Bitary::Bitwarr.new(32, bytes: nil, bpi: 8)

      instance.bit_at!(23)
      instance.unbit_at!(23)

      expect(instance.bit_at(23)).to eq(0)
    end

    it(
      'unsets the bit at given bit index when size is not divisible by bpi ' \
      'and pre-init from byte array'
    ) do
      instance = Bitary::Bitwarr.new(25, bytes: [1, 2, 3], bpi: 8)

      instance.unbit_at!(23)

      expect(instance.bit_at(23)).to eq(0)
    end

    it(
      'unsets the bit at given bit index when size is not divisible by bpi ' \
      'and not pre-init from byte array'
    ) do
      instance = Bitary::Bitwarr.new(35, bytes: nil, bpi: 8)

      instance.bit_at!(34)
      instance.unbit_at!(34)

      expect(instance.bit_at(34)).to eq(0)
    end
  end

  describe '#each_byte' do
    it "iterates over each internal array's byte when bpi == 8" do
      instance = Bitary::Bitwarr.new(nil, bytes: [1, 2, 3], bpi: 8)
      counter = 0

      instance.each_byte do |byte|
        case counter
        when 0 then expect(byte).to eq(1)
        when 1 then expect(byte).to eq(2)
        when 2 then expect(byte).to eq(3)
        end
        counter += 1
      end

      expect(counter).to eq(3)
    end

    it "iterates over each internal array's byte when bpi > 8" do
      instance = Bitary::Bitwarr.new(nil, bytes: [1, 2, 3], bpi: 32)
      counter = 0

      instance.each_byte do |byte|
        case counter
        when 0 then expect(byte).to eq(1)
        when 1 then expect(byte).to eq(2)
        when 2 then expect(byte).to eq(3)
        when 3 then expect(byte).to eq(0)
        end
        counter += 1
      end

      expect(counter).to eq(4)
    end
  end

  describe '#to_s' do
    it 'converts the internal array to a binary string when bpi == 8' do
      instance = Bitary::Bitwarr.new(nil, bytes: [1, 2, 3], bpi: 8)

      expect(instance.to_s).to eq('00000001 00000010 00000011')
    end

    it 'converts the internal array to a binary string when bpi == 16' do
      instance = Bitary::Bitwarr.new(nil, bytes: [1, 2, 3], bpi: 16)

      expect(instance.to_s).to eq('0000000100000010 0000001100000000')
    end

    it 'converts the internal array to a binary string when bpi == 32' do
      instance = Bitary::Bitwarr.new(nil, bytes: [1, 2, 3], bpi: 32)

      expect(instance.to_s).to eq('00000001000000100000001100000000')
    end

    it 'converts the internal array to a binary string when bpi == 64' do
      instance = Bitary::Bitwarr.new(nil, bytes: [1, 2, 3], bpi: 64)

      expect(instance.to_s).to eq(
        '0000000100000010000000110000000000000000000000000000000000000000'
      )
    end
  end
end
