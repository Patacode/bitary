# frozen_string_literal: true

require_relative 'bitary/size'
require_relative 'bitary/version'
require_relative 'bitary/handler'
require_relative 'bitary/factory'
require_relative 'bitary/bitwarr'

class Bitary
  include Size

  def initialize(initial_data, bpi: LONG)
    raise ArgumentError unless [BYTE, SHORT, INT, LONG].include?(bpi)

    @internal_array = Bitwarr.new(initial_data, bpi: bpi)
  end

  def [](index)
    raise IndexError if index.negative? || index >= @internal_array.bitsize

    item_index = compute_item_index(index)
    item_bit_size = compute_item_bit_size(item_index)
    item = @internal_array[item_index]

    Factory.make('Handler::Get', item).execute(
      index: index % @internal_array.bpi,
      size: item_bit_size
    )
  end

  def []=(index, value)
    raise IndexError if index.negative? || index >= @internal_array.bitsize

    bit = map_to_bit(value)
    item_index = compute_item_index(index)
    item_bit_size = compute_item_bit_size(item_index)
    item = @internal_array[item_index]

    @internal_array[item_index] =
      if bit == 1
        Factory.make('Handler::Set', item).execute(
          index: index % @internal_array.bpi,
          size: item_bit_size
        )
      else
        Factory.make('Handler::Unset', item).execute(
          index: index % @internal_array.bpi,
          size: item_bit_size
        )
      end
  end

  def set(index)
    self[index] = 1
  end

  def unset(index)
    self[index] = 0
  end

  def each_byte(&proc)
    res = decrease_items_size(@internal_array, BYTE, @internal_array.bpi)
    proc ? res.each { |byte| proc.call(byte) } : res.each
  end

  def to_a
    @internal_array.to_a
  end

  def to_s
    @internal_array.map do |item|
      format("%0#{@internal_array.bpi}d", item.to_s(2))
    end.join(' ')
  end

  def bpi=(value)
    raise ArgumentError unless [BYTE, SHORT, INT, LONG].include?(value)

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

  def map_to_bit(value)
    if value
      if value.is_a?(Integer)
        value.zero? ? 0 : 1
      else
        1
      end
    else
      0
    end
  end

  def compute_item_bit_size(index)
    if index == @internal_array.length - 1
      @internal_array.bitsize - ((@internal_array.length - 1) * @internal_array.bpi)
    else
      @internal_array.bpi
    end
  end

  def compute_item_index(index)
    index / @internal_array.bpi
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
