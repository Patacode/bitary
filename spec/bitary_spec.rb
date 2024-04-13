# frozen_string_literal: true

require 'bitary'

RSpec.shared_examples :bit_access do |method|
  let(:instance) { Bitary.new(27, bytes: [1, 2, 3], bpi: 8) }

  it 'gets the bit at given bit index' do
    expect(instance.send(method, 23)).to eq(1)
    expect(instance.send(method, 24)).to eq(0)
  end

  it 'raises an IndexError if given index is out of bounds' do
    expect { instance.send(method, -1) }.to raise_error(IndexError)
    expect { instance.send(method, 27) }.to raise_error(IndexError)
  end

  it 'raises a TypeError if given index is not an Integer' do
    expect { instance.send(method, 'invalid') }.to raise_error(TypeError)
  end
end

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
    it(
      'returns a new instance with given byte array, initial bit capacity ' \
      'and bits per item'
    ) do
      expect(Bitary.new(128, bytes: [255, 10, 20], bpi: 16)).to be_instance_of(
        Bitary
      )
    end

    it 'returns a new instance with no args' do
      expect(Bitary.new).to be_instance_of(Bitary)
    end

    it 'returns a new instance with given initial bit capacity' do
      expect(Bitary.new(10)).to be_instance_of(Bitary)
    end

    it 'returns a new instance with given nil initial bit capacity' do
      expect(Bitary.new(nil)).to be_instance_of(Bitary)
    end

    it 'returns a new instance with given byte array' do
      expect(Bitary.new(bytes: [255, 10, 20])).to be_instance_of(Bitary)
    end

    it 'returns a new instance with given bits per item' do
      expect(Bitary.new(bpi: 32)).to be_instance_of(Bitary)
    end

    it 'returns a new instance with given nil byte array' do
      expect(Bitary.new(bytes: nil)).to be_instance_of(Bitary)
    end

    it(
      'returns a new instance with given byte array and initial bit ' \
      'capacity more than default'
    ) do
      expect(Bitary.new(128, bytes: [255, 10, 20])).to be_instance_of(Bitary)
    end

    it(
      'returns a new instance with given byte array and initial bit ' \
      'capacity less than default'
    ) do
      expect(Bitary.new(20, bytes: [255, 10, 20])).to be_instance_of(Bitary)
    end

    it(
      'returns a new instance with given byte array and initial bit ' \
      'capacity equal to default'
    ) do
      expect(Bitary.new(24, bytes: [255, 10, 20])).to be_instance_of(Bitary)
    end

    it(
      'returns a new instance with given initial bit capacity and bits per item'
    ) do
      expect(Bitary.new(20, bpi: 8)).to be_instance_of(Bitary)
    end

    it 'returns a new instance with given byte array and bits per item' do
      expect(Bitary.new(bytes: [1, 2, 3], bpi: 8)).to be_instance_of(Bitary)
    end

    it 'raises an ArgumentError if initial bit capacity is 0' do
      expect { Bitary.new(0) }.to raise_error(ArgumentError)
    end

    it 'raises an ArgumentError if initial bit capacity is negative' do
      expect { Bitary.new(-5) }.to raise_error(ArgumentError)
    end

    it 'raises an ArgumentError if bpi is an Integer not in [8, 16, 32, 64]' do
      expect { Bitary.new(100, bpi: 9) }.to raise_error(ArgumentError)
    end

    it 'raises a TypeError if bpi is not an Integer' do
      expect { Bitary.new(100, bpi: 'invalid') }.to raise_error(TypeError)
    end

    it 'raises an ArgumentError if more than 1 pos args are given' do
      expect { Bitary.new(100, 2) }.to raise_error(ArgumentError)
    end

    it 'raise an ArgumentError if kwargs other than bpi and bytes are given' do
      expect { Bitary.new(invalid: 'kwarg') }.to raise_error(ArgumentError)
    end

    it 'raises a TypeError if initial bit capacity is not an Integer or nil' do
      expect { Bitary.new('invalid') }.to raise_error(TypeError)
    end

    it 'raises a TypeError if byte array is not an Array or nil' do
      expect { Bitary.new(bytes: { invalid: 1 }) }.to raise_error(TypeError)
    end
  end

  describe '#bits' do
    let(:instance) { Bitary.new(73) }

    it 'returns the number of bits used by the bit array' do
      expect(instance.bits).to eq(73)
    end

    it 'raises an ArgumentError if pos args are given' do
      expect { instance.bits(1) }.to raise_error(ArgumentError)
    end

    it 'raises an ArgumentError if kwargs are given' do
      expect { instance.bits(a: 1) }.to raise_error(ArgumentError)
    end
  end

  describe '#bpi' do
    let(:instance) { Bitary.new(bpi: 8) }

    it 'returns the number of bits used per item' do
      expect(instance.bpi).to eq(8)
    end

    it 'returns a default value of 64 when not given in constructor' do
      instance = Bitary.new

      expect(instance.bpi).to eq(64)
    end

    it 'raises an ArgumentError if pos args are given' do
      expect { instance.bpi(1) }.to raise_error(ArgumentError)
    end

    it 'raises an ArgumentError if kwargs are given' do
      expect { instance.bpi(a: 1) }.to raise_error(ArgumentError)
    end
  end

  describe '#bpi=' do
    let(:instance) { Bitary.new(bytes: [1, 2, 3, 4, 5], bpi: 32) }

    it 'increases the bits used per item when value is > than actual bpi' do
      instance.bpi = 32

      expect(instance.to_a).to eq([16_909_060, 83_886_080])
    end

    it 'decreases the bits used per item when value is < than actual bpi' do
      instance.bpi = 16

      expect(instance.to_a).to eq([258, 772, 1_280, 0])
    end

    it(
      'raises an ArgumentError if value is an Integer not in [8, 16, 32, 64]'
    ) do
      expect { instance.bpi = 40 }.to raise_error(ArgumentError)
    end

    it 'raises a TypeError if value is not an Integer' do
      expect { instance.bpi = 'invalid' }.to raise_error(TypeError)
    end
  end

  describe '#to_a' do
    let(:instance) { Bitary.new(bytes: [1, 2, 3, 4, 5], bpi: 32) }

    it 'returns a shallow copy of internal array' do
      clone = instance.to_a
      clone[0] = 33

      expect(instance.to_a).to eq([16_909_060, 83_886_080])
    end

    it 'raises an ArgumentError if pos args are given' do
      expect { instance.to_a(1) }.to raise_error(ArgumentError)
    end

    it 'raises an ArgumentError if kwargs are given' do
      expect { instance.to_a(a: 1) }.to raise_error(ArgumentError)
    end
  end

  describe '#[]' do
    include_examples :bit_access, :[]
  end

  describe '#[]=' do
    let(:instance) { Bitary.new(bytes: [148, 145, 5], bpi: 8) }

    it 'sets the bit at given index to 1 if given value is truthy but 0' do
      instance[1] = []
      instance[14] = true
      instance[15] = 0
      instance[9] = 1

      expect(instance[1]).to eq(1)
      expect(instance[14]).to eq(1)
      expect(instance[15]).to eq(0)
      expect(instance[9]).to eq(1)
    end

    it 'sets the bit at given index to 0 if given value is falsy or 0' do
      instance[0] = nil
      instance[3] = false
      instance[16] = 0

      expect(instance[0]).to eq(0)
      expect(instance[3]).to eq(0)
      expect(instance[16]).to eq(0)
    end

    it 'raises an IndexError if given index is out of bounds' do
      expect { instance[-1] = 1 }.to raise_error(IndexError)
      expect { instance[24] = 0 }.to raise_error(IndexError)
    end

    it 'raises a TypeError if given index is not an Integer' do
      expect { instance['invalid'] = 3 }.to raise_error(TypeError)
    end
  end

  describe '#at' do
    include_examples :bit_access, :at
  end

  describe '#set' do
    let(:instance) { Bitary.new(bytes: [148, 145, 5], bpi: 8) }

    it 'sets the bit at given index' do
      instance.set(1)
      instance.set(14)
      instance.set(15)
      instance.set(9)

      expect(instance[1]).to eq(1)
      expect(instance[14]).to eq(1)
      expect(instance[15]).to eq(1)
      expect(instance[9]).to eq(1)
    end

    it 'raises an IndexError if given index is out of bounds' do
      expect { instance.set(-1) }.to raise_error(IndexError)
      expect { instance.set(24) }.to raise_error(IndexError)
    end

    it 'raises a TypeError if given index is not an Integer' do
      expect { instance.set('invalid') }.to raise_error(TypeError)
    end
  end

  describe '#unset' do
    let(:instance) { Bitary.new(bytes: [148, 145, 5], bpi: 8) }

    it 'unsets the bit at given index (to 0)' do
      instance.unset(0)
      instance.unset(3)
      instance.unset(5)

      expect(instance[0]).to eq(0)
      expect(instance[3]).to eq(0)
      expect(instance[5]).to eq(0)
    end

    it 'raises an IndexError if given index is out of bounds' do
      expect { instance.unset(-1) }.to raise_error(IndexError)
      expect { instance.unset(24) }.to raise_error(IndexError)
    end

    it 'raises a TypeError if given index is not an Integer' do
      expect { instance.unset('invalid') }.to raise_error(TypeError)
    end
  end

  describe '#each_byte' do
    let(:instance) { Bitary.new(bytes: [255, 10, 20], bpi: 8) }

    it 'iterates over each byte of the bit array' do
      counter = 0
      instance.each_byte do |byte|
        case counter
        when 0 then expect(byte).to eq(255)
        when 1 then expect(byte).to eq(10)
        when 2 then expect(byte).to eq(20)
        end

        counter += 1
      end

      expect(counter).to eq(3)
    end

    it 'raises an ArgumentError if pos args are provided' do
      expect { instance.each_byte(->(byte) { p byte }) }.to raise_error(
        ArgumentError
      )
    end

    it 'raises an ArgumentError if kwargs are provided' do
      expect { instance.each_byte(a: 1) }.to raise_error(ArgumentError)
    end
  end

  describe '#to_s' do
    let(:instance) { Bitary.new(bytes: [148, 145, 5], bpi: 8) }

    it 'converts the bit array to a binary string' do
      expect(instance.to_s).to eq('10010100 10010001 00000101')
    end

    it 'raises an ArgumentError if pos args are given' do
      expect { instance.to_s(16) }.to raise_error(ArgumentError)
    end

    it 'raises an ArgumentError if kwargs are given' do
      expect { instance.to_s(a: 1) }.to raise_error(ArgumentError)
    end
  end
end
