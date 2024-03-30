# frozen_string_literal: true

require_relative 'bitary/size'
require_relative 'bitary/version'
require_relative 'bitary/handler'
require_relative 'bitary/factory'
require_relative 'bitary/bitwarr'
require_relative 'bitary/decorator'
require_relative 'bitary/mapper'

class Bitary
  include Size

  def initialize(initial_data, bpi: LONG)
    check_bpi(bpi)

    @internal_array = Bitwarr.new(initial_data, bpi:)
  end

  def [](index)
    @internal_array.bit_at(index)
  end

  def []=(index, value)
    case Mapper::ObjToBit.new.map(value)
    when 0 then @internal_array.unbit_at!(index)
    else @internal_array.bit_at!(index)
    end
  end

  def set(index)
    self[index] = 1
  end

  def unset(index)
    self[index] = 0
  end

  def each_byte(&)
    @internal_array.each_byte(&)
  end

  def to_a
    @internal_array.to_a
  end

  def to_s
    @internal_array.to_s
  end

  def bpi=(value)
    check_bpi(value)

    @internal_array = Bitwarr.new(
      if value > @internal_array.bpi
        increase_items_size(@internal_array, value, @internal_array.bpi)
      else
        decrease_items_size(@internal_array, value, @internal_array.bpi)
      end,
      bpi: @internal_array.bpi
    )

    @internal_array.bpi = value
  end

  def size
    @internal_array.bitsize
  end

  def bpi
    @internal_array.bpi
  end

  private

  def check_bpi(bpi)
    raise ArgumentError unless [BYTE, SHORT, INT, LONG].include?(bpi)
  end

  def increase_items_size(array, new_size, bpi)
    processed_bits = 0
    array.each_with_object([0]) do |value, acc|
      offset = bpi
      if processed_bits >= new_size
        offset = 0
        acc << 0
        processed_bits = 0
      end

      acc[-1] = Factory.make('Handler::Append', acc[-1]).execute(
        offset:,
        value:
      )
      processed_bits += bpi
    end
  end

  def decrease_items_size(array, new_size, bpi)
    array.each_with_object([]) do |item, acc|
      acc.concat(explode_item(item, new_size, bpi))
    end
  end

  def explode_item(item, new_size, bpi)
    res = []
    offset = bpi
    mask = (2**new_size) - 1

    while offset.positive?
      offset -= new_size
      res << ((item >> offset) & mask)
    end

    res
  end

  alias at []
end
