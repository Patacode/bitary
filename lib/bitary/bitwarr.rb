# frozen_string_literal: true

class Bitary
  class Bitwarr
    attr_reader :bpi, :bitsize

    DEFAULT_INIT_CAP = Bitary::Size::LONG * 2

    def initialize(init_cap = nil, bytes: nil, bpi: Bitary::LONG)
      @array = init_array(init_cap, bytes, bpi)
      @bitsize = init_bitsize(init_cap, bytes)
      @bpi = bpi
    end

    def [](bit_index) = @array[item_index(bit_index)]

    def []=(bit_index, value)
      @array[item_index(bit_index)] = value
    end

    def bit_at(index) = (self[index] >> (@bpi - (index % @bpi) - 1)) & 0x1
    def bit_at!(index) = self[index] |= 2**(@bpi - (index % @bpi) - 1)

    def unbit_at!(index)
      self[index] &= ((2**@bpi) - 1 - (2**(@bpi - (index % @bpi) - 1)))
    end

    def to_s = @array.map { |item| to_binstr(item) }.join(' ')
    def to_a = @array.clone

    def each_byte(&proc)
      @array.each do |item|
        explode_item(item, Bitary::BYTE, @bpi, &proc)
      end
    end

    def bpi=(value)
      return if value == @bpi

      update_items_size!(value)
      @bpi = value
    end

    private

    def init_bitsize(init_cap, bytes)
      if init_cap.nil?
        if bytes.nil?
          DEFAULT_INIT_CAP
        else
          bytes.length * Bitary::BYTE
        end
      else
        init_cap
      end
    end

    def init_array(init_cap, bytes, bpi)
      if init_cap.nil? && bytes.nil?
        [0] * (DEFAULT_INIT_CAP / bpi.to_f).ceil
      elsif !init_cap.nil? && bytes.nil?
        [0] * (init_cap / bpi.to_f).ceil
      elsif init_cap.nil? && !bytes.nil?
        if bpi == Bitary::BYTE
          bytes.clone
        else
          increase_items_size(bytes, bpi, Bitary::BYTE)
        end
      else
        bytes.clone
      end
    end

    def item_index(bit_index)
      bit_index / @bpi
    end

    def to_binstr(item)
      format("%0#{@bpi}d", item.to_s(2))
    end

    def update_items_size!(new_size)
      @array = update_items_size(@array, new_size, @bpi)
    end

    def update_items_size(array, new_size, bpi)
      if new_size > bpi
        increase_items_size(array, new_size, bpi)
      else
        decrease_items_size(array, new_size, bpi)
      end
    end

    def append_bits(item, bpi, addend)
      (item << bpi) | addend
    end

    def increase_items_size(array, new_size, bpi)
      processed_bits = 0
      res = array.each_with_object([0]) do |item, acc|
        if processed_bits == new_size
          acc << 0
          processed_bits = 0
        end

        acc[-1] = append_bits(acc[-1], bpi, item)
        processed_bits += bpi
      end

      while processed_bits < new_size
        res[-1] = append_bits(res[-1], bpi, 0)
        processed_bits += bpi
      end

      res
    end

    def decrease_items_size(array, new_size, bpi)
      array.each_with_object([]) do |item, acc|
        explode_item(item, new_size, bpi) do |new_item|
          acc << new_item
        end
      end
    end

    def explode_item(item, new_size, bpi)
      mask = (2**new_size) - 1
      (bpi / new_size).times do |i|
        yield ((item >> (bpi - (new_size * (i + 1)))) & mask)
      end
    end
  end
end
