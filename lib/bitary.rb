# frozen_string_literal: true

require_relative 'bitary/size'
require_relative 'bitary/version'
require_relative 'bitary/bitwarr'

class Bitary
  include Size

  def initialize(init_cap = nil, bytes: nil, bpi: LONG)
    check_init_cap(init_cap)
    check_bytes(bytes)
    check_bpi(bpi)

    @bitwarr = Bitwarr.new(init_cap, bytes:, bpi:)
  end

  def [](index)
    check_bit_index(index)

    @bitwarr.bit_at(index)
  end

  def []=(index, value)
    check_bit_index(index)

    case obj_to_bit(value)
    when 0 then @bitwarr.unbit_at!(index)
    else @bitwarr.bit_at!(index)
    end
  end

  def set(index)
    self[index] = 1
  end

  def unset(index)
    self[index] = 0
  end

  def each_byte(&)
    @bitwarr.each_byte(&)
  end

  def to_a
    @bitwarr.to_a
  end

  def to_s
    @bitwarr.to_s
  end

  def bpi=(value)
    check_bpi(value)

    @bitwarr.bpi = value
  end

  def bits
    @bitwarr.bits
  end

  def bpi
    @bitwarr.bpi
  end

  private

  def check_init_cap(init_cap)
    return if init_cap.nil?

    raise TypeError unless init_cap.is_a?(Integer)
    raise ArgumentError unless init_cap.positive?
  end

  def check_bytes(bytes)
    return if bytes.nil?

    raise TypeError unless bytes.is_a?(Array)
  end

  def check_bpi(bpi)
    raise TypeError unless bpi.is_a?(Integer)
    raise ArgumentError unless [BYTE, SHORT, INT, LONG].include?(bpi)
  end

  def check_bit_index(bit_index)
    raise TypeError unless bit_index.is_a?(Integer)
    raise IndexError if bit_index.negative? || bit_index >= @bitwarr.bits
  end

  def obj_to_bit(value)
    !!value ? truthy_to_bit(value) : 0
  end

  def truthy_to_bit(value)
    value.is_a?(Integer) ? int_to_bit(value) : 1
  end

  def int_to_bit(value)
    value.zero? ? 0 : 1
  end

  alias at []
end
