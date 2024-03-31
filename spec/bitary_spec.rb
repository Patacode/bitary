# frozen_string_literal: true

require 'bitary'

RSpec.describe Bitary do
  it 'has BYTE constant referring to size of 8 bits' do
    expect(Bitary::BYTE).to eq(8)
  end

  it 'has SHORT constant referring to size of 16 bits' do
    expect(Bitary::SHORT).to eq(16)
  end

  it 'has INT constant referring to size of 32 bits' do
    expect(Bitary::INT).to eq(32)
  end

  it 'has LONG constant referring to size of 64 bits' do
    expect(Bitary::LONG).to eq(64)
  end

  describe '::new' do
    it 'returns a new bit array of the desired size' do
      Bitary.new(10)
    end

    it 'returns a new bit array based on some given integer array' do
      Bitary.new([255, 10, 20])
    end

    it 'returns a new bit array using some given element size in bits' do
      Bitary.new(100, bpi: 64)
    end

    it 'raises an ArgumentError if bpi is not in [8, 16, 32, 64]' do
      expect { Bitary.new(100, bpi: 9) }.to raise_error(
        ArgumentError
      )

      expect { Bitary.new(100, bpi: 24) }.to raise_error(
        ArgumentError
      )
    end
  end

  describe '#size' do
    it 'returns the size of the bit array, in bits' do
      bit_array1 = Bitary.new(10)
      bit_array2 = Bitary.new([255, 10, 20])
      bit_array3 = Bitary.new(100, bpi: 64)

      expect(bit_array1.size).to eq(10)
      expect(bit_array2.size).to eq(192)
      expect(bit_array3.size).to eq(100)
    end
  end

  describe '#bpi' do
    it 'returns the number of bits used by each item in the internal array' do
      bit_array = Bitary.new(10, bpi: 32)

      expect(bit_array.bpi).to eq(32)
    end

    it 'returns a default value of 64' do
      bit_array = Bitary.new(10)

      expect(bit_array.bpi).to eq(64)
    end
  end

  describe '#bpi=' do
    it 'updates the bits used per item by merging existing ones (increase)' do
      bit_array = Bitary.new([255, 10, 20], bpi: 16)

      bit_array.bpi = 64

      expect(bit_array.to_a).to eq([1_095_217_315_860])
    end

    it 'updates the bits used per item by merging existing ones (decrease)' do
      bit_array = Bitary.new([255, 10, 20], bpi: 16)

      bit_array.bpi = 8

      expect(bit_array.to_a).to eq([0, 255, 0, 10, 0, 20])
    end

    it 'handles decreasing with reduced last item' do
      bit_array = Bitary.new(127)

      bit_array[119] = 1
      bit_array.bpi = 8 # last item will have 7 bits

      expect(bit_array[119]).to eq(1)
    end

    it 'raises an ArgumentError if value is not in [8, 16, 32, 64]' do
      bit_array = Bitary.new(10)

      expect { bit_array.bpi = 40 }.to raise_error(ArgumentError)
      expect { bit_array.bpi = 65 }.to raise_error(ArgumentError)
    end
  end

  describe '#to_a' do
    it 'returns accurately the internal array backed by the bit array' do
      bit_array1 = Bitary.new(10)
      bit_array2 = Bitary.new([255, 10, 20])
      bit_array3 = Bitary.new([300, 10, 20], bpi: 16)
      bit_array4 = Bitary.new(16, bpi: 8)

      expect(bit_array1.to_a).to eq([0])
      expect(bit_array2.to_a).to eq([255, 10, 20])
      expect(bit_array3.to_a).to eq([300, 10, 20])
      expect(bit_array4.to_a).to eq([0, 0])
    end

    it 'returns a clone of the internal array backed by the bit array' do
      bit_array = Bitary.new(10)

      expect(bit_array.to_a).not_to be(
        bit_array.instance_variable_get(:@internal_array)
      )
    end
  end

  describe '#[]' do
    it 'returns the value of the bit at given index' do
      bit_array = Bitary.new([148, 145, 5], bpi: 8)

      expect(bit_array[0]).to eq(1)
      expect(bit_array[8]).to eq(1)
      expect(bit_array[14]).to eq(0)
      expect(bit_array[23]).to eq(1)
    end

    it 'raises an IndexError if given index is out of bounds' do
      bit_array = Bitary.new(10)

      expect { bit_array[-1] }.to raise_error(IndexError)
      expect { bit_array[10] }.to raise_error(IndexError)
    end
  end

  describe '#[]=' do
    it 'sets the bit at given index to 1 if given value is truthy but 0' do
      bit_array = Bitary.new([148, 145, 5], bpi: 8)

      bit_array[1] = []
      bit_array[14] = true
      bit_array[15] = 0
      bit_array[9] = 1

      expect(bit_array[1]).to eq(1)
      expect(bit_array[14]).to eq(1)
      expect(bit_array[15]).to eq(0)
      expect(bit_array[9]).to eq(1)
    end

    it 'sets the bit at given index to 0 if given value is falsy or 0' do
      bit_array = Bitary.new([148, 145, 5], bpi: 8)

      bit_array[0] = nil
      bit_array[3] = false
      bit_array[16] = 0

      expect(bit_array[0]).to eq(0)
      expect(bit_array[3]).to eq(0)
      expect(bit_array[16]).to eq(0)
    end

    it 'raises an IndexError if given index is out of bounds' do
      bit_array = Bitary.new(10)

      expect { bit_array[-1] = 1 }.to raise_error(IndexError)
      expect { bit_array[10] = 0 }.to raise_error(IndexError)
    end
  end

  describe '#at' do
    it 'returns the value of the bit at given index (acts as #[])' do
      bit_array = Bitary.new([148, 145, 5], bpi: 8)

      expect(bit_array.at(0)).to eq(1)
      expect(bit_array.at(8)).to eq(1)
      expect(bit_array.at(14)).to eq(0)
      expect(bit_array.at(23)).to eq(1)
    end

    it 'raises an IndexError if given index is out of bounds (acts as #[])' do
      bit_array = Bitary.new(10)

      expect { bit_array.at(-1) }.to raise_error(IndexError)
      expect { bit_array.at(10) }.to raise_error(IndexError)
    end
  end

  describe '#set' do
    it 'sets the bit at given index (to 1)' do
      bit_array = Bitary.new([148, 145, 5], bpi: 8)

      bit_array.set(1)
      bit_array.set(14)
      bit_array.set(15)
      bit_array.set(9)

      expect(bit_array[1]).to eq(1)
      expect(bit_array[14]).to eq(1)
      expect(bit_array[15]).to eq(1)
      expect(bit_array[9]).to eq(1)
    end

    it 'raises an IndexError if given index is out of bounds' do
      bit_array = Bitary.new(10)

      expect { bit_array.set(-1) }.to raise_error(IndexError)
      expect { bit_array.set(10) }.to raise_error(IndexError)
    end
  end

  describe '#unset' do
    it 'unsets the bit at given index (to 0)' do
      bit_array = Bitary.new([148, 145, 5], bpi: 8)

      bit_array.unset(0)
      bit_array.unset(3)
      bit_array.unset(5)

      expect(bit_array[0]).to eq(0)
      expect(bit_array[3]).to eq(0)
      expect(bit_array[5]).to eq(0)
    end

    it 'raises an IndexError if given index is out of bounds' do
      bit_array = Bitary.new(10)

      expect { bit_array.unset(-1) }.to raise_error(IndexError)
      expect { bit_array.unset(10) }.to raise_error(IndexError)
    end
  end

  describe '#to_s' do
    it 'returns the binary string representation of the whole bit array' do
      bit_array1 = Bitary.new([148, 145, 5], bpi: 8)

      expect(bit_array1.to_s).to eq('10010100 10010001 00000101')
    end
  end

  describe '#each_byte' do
    it 'iterates over each byte of the bit array' do
      bit_array = Bitary.new([255, 10, 20], bpi: 8)

      index = 0
      bit_array.each_byte do |byte|
        case index
        when 0 then expect(byte).to eq(255)
        when 1 then expect(byte).to eq(10)
        when 2 then expect(byte).to eq(20)
        end

        index += 1
      end
    end
  end
end
