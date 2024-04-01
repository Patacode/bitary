# frozen_string_literal: true

class Bitary
  class Bitwarr
    attr_reader :bpi, :bitsize

    def initialize(initial_data, bpi: Bitary::LONG)
      @bitsize = init_bitsize(initial_data, bpi)
      @array = init_array(initial_data, @bitsize, bpi)
      @bpi = init_bpi(initial_data, bpi)

      self.bpi = bpi
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

    def method_missing(method, *, &)
      @array.respond_to?(method) ? @array.send(method, *, &) : super
    end

    def respond_to_missing?(method, include_all = false)
      @array.respond_to?(method, include_all) || super
    end

    private

    def init_bpi(initial_data, bpi)
      initial_data.is_a?(Array) ? Bitary::BYTE : bpi
    end

    def init_bitsize(initial_data, bpi)
      initial_data.is_a?(Array) ? bpi * initial_data.length : initial_data
    end

    def init_array(initial_data, bitsize, bpi)
      if initial_data.is_a?(Array)
        initial_data.clone
      else
        [0] * (bitsize / bpi.to_f).ceil
      end
    end

    def item_index(bit_index)
      bit_index / @bpi
    end

    def to_binstr(item)
      format("%0#{@bpi}d", item.to_s(2))
    end

    def operate_bit_at(operation, index)
      Factory
        .make("Handler::#{operation.capitalize}", self[index])
        .execute(
          index: index % @bpi,
          size: @bpi
        )
    end

    def operate_bit_at!(operation, index)
      self[index] = operate_bit_at(operation, index)
    end

    def update_items_size!(value)
      value > @bpi ? increase_items_size!(value) : decrease_items_size!(value)
    end

    def append_bits(item, bpi, addend)
      Factory.make('Handler::Append', item).execute(
        offset: bpi,
        value: addend
      )
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

    def increase_items_size!(value)
      @array = increase_items_size(@array, value, @bpi)
    end

    def decrease_items_size(array, new_size, bpi)
      array.each_with_object([]) do |item, acc|
        explode_item(item, new_size, bpi) do |new_item|
          acc << new_item
        end
      end
    end

    def decrease_items_size!(value)
      @array = decrease_items_size(@array, value, @bpi)
    end

    def explode_item(item, new_size, bpi)
      mask = (2**new_size) - 1
      (bpi / new_size).times do |i|
        yield ((item >> (bpi - (new_size * (i + 1)))) & mask)
      end
    end
  end
end
