# frozen_string_literal: true

require_relative 'bitary/size'
require_relative 'bitary/version'

class Bitary
  include Size

  attr_reader :size, :bits_per_item

  def initialize(initial_data, bits_per_item: LONG)
    raise ArgumentError unless [BYTE, SHORT, INT, LONG].include?(bits_per_item)

    @size = init_size(initial_data, bits_per_item)
    @internal_array = init_internal_array(initial_data, @size, bits_per_item)
    @bits_per_item = bits_per_item
  end

  def [](index)
    raise IndexError if index.negative? || index >= @size

    item_index = compute_item_index(index)
    item_bit_size = compute_item_bit_size(item_index)
    offset = compute_relative_offset(index, item_bit_size)
    item = @internal_array[item_index]

    Handler::Get.new(item).execute(
      index: index % @bits_per_item,
      size: item_bit_size
    )
  end

  def []=(index, value)
    raise IndexError if index.negative? || index >= @size

    bit = map_to_bit(value)
    item_index = compute_item_index(index)
    item_bit_size = compute_item_bit_size(item_index)
    offset = compute_relative_offset(index, item_bit_size)
    item = @internal_array[item_index]

    @internal_array[item_index] =
      if bit == 1
        Handler::Set.new(item).execute(
          index: index % @bits_per_item,
          size: item_bit_size
        )
      else
        Handler::Unset.new(item).execute(
          index: index % @bits_per_item,
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
    res = decrease_items_size(@internal_array, BYTE, @bits_per_item)
    proc ? res.each { |byte| proc.call(byte) } : res.each
  end

  def to_a
    @internal_array.clone
  end

  def to_s
    @internal_array.map do |item|
      format("%0#{@bits_per_item}d", item.to_s(2))
    end.join(' ')
  end

  def bits_per_item=(value)
    raise ArgumentError unless [BYTE, SHORT, INT, LONG].include?(value)

    @internal_array =
      if value > @bits_per_item
        increase_items_size(@internal_array, value, @bits_per_item)
      else
        decrease_items_size(@internal_array, value, @bits_per_item)
      end

    @bits_per_item = value
  end

  private

  def init_size(initial_data, bits_per_item)
    if initial_data.is_a?(Array)
      bits_per_item * initial_data.length
    else
      initial_data
    end
  end

  def init_internal_array(initial_data, size, bits_per_item)
    res = [0] * (size / bits_per_item.to_f).ceil
    initial_data.is_a?(Array) ? initial_data.clone : res
  end

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
      size - ((@internal_array.length - 1) * @bits_per_item)
    else
      @bits_per_item
    end
  end

  def compute_item_index(index)
    index / @bits_per_item
  end

  def compute_relative_offset(index, size)
    size - (index % @bits_per_item) - 1
  end

  def append_bits(value, offset, bits)
    (value << offset) | bits
  end

  def increase_items_size(array, new_size, bpi)
    processed_bits = 0
    array.each_with_object([0]) do |item, acc|
      offset = bpi
      if processed_bits >= new_size
        offset = 0
        acc << 0
        processed_bits = 0
      end

      acc[-1] = append_bits(acc[-1], offset, item)
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
