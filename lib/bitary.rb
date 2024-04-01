# frozen_string_literal: true

require_relative 'bitary/size'
require_relative 'bitary/version'
require_relative 'bitary/bitwarr'

class Bitary
  include Size

  def initialize(initial_data, bpi: LONG)
    check_initial_data(initial_data)
    check_bpi(bpi)

    @bitwarr = Bitwarr.new(initial_data, bpi:)
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
    @bitwarr.to_a.clone
  end

  def to_s
    @bitwarr.to_s
  end

  def bpi=(value)
    check_bpi(value)

    @bitwarr.bpi = value
  end

  def size
    @bitwarr.bitsize
  end

  def bpi
    @bitwarr.bpi
  end

  private

  def check_initial_data(initial_data)
    raise ArgumentError unless [Array, Integer].include?(initial_data.class)
  end

  def check_bpi(bpi)
    raise ArgumentError unless [BYTE, SHORT, INT, LONG].include?(bpi)
  end

  def check_bit_index(bit_index)
    raise ArgumentError unless bit_index.is_a?(Integer)
    raise IndexError if bit_index.negative? || bit_index >= @bitwarr.bitsize
  end

  def obj_to_bit(value)
    case !!value
    when true then truthy_to_bit(value)
    when false then 0
    end
  end

  def truthy_to_bit(value)
    value.is_a?(Integer) ? int_to_bit(value) : 1
  end

  def int_to_bit(value)
    value.zero? ? 0 : 1
  end

  alias at []
end
