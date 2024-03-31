# frozen_string_literal: true

class Bitary
  class Bitwarr
    attr_reader :bpi, :bitsize

    def initialize(initial_data, bpi: Bitary::LONG)
      check_initial_data(initial_data)
      check_bpi(bpi)

      @bitsize = init_bitsize(initial_data, bpi)
      @array = init_array(initial_data, @bitsize, bpi)
      @bpi = init_bpi(initial_data, bpi)

      self.bpi = bpi
    end

    def method_missing(method, *, &)
      @array.respond_to?(method) ? @array.send(method, *, &) : super
    end

    def respond_to_missing?(method, include_all = false)
      @array.respond_to?(method, include_all) || super
    end

    def [](bit_index)
      @array[item_index(bit_index)]
    end

    def []=(bit_index, value)
      raise ArgumentError unless value.is_a?(Integer)

      @array[item_index(bit_index)] = value
    end

    def item_index(bit_index)
      check_bit_index(bit_index)

      bit_index / @bpi
    end

    def bit_at(index)
      operate_bit_at(:get, index)
    end

    def bit_at!(index)
      operate_bit_at!(:set, index)
    end

    def unbit_at!(index)
      operate_bit_at!(:unset, index)
    end

    def each_byte(&proc)
      @array.each do |item|
        explode_item(item, Bitary::BYTE, @bpi, &proc)
      end
    end

    def to_s
      @array.map { |item| format("%0#{@bpi}d", item.to_s(2)) }.join(' ')
    end

    def bpi=(value)
      check_bpi(value)
      return if value == @bpi

      update_items_size!(value)

      @bpi = value
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

    def check_initial_data(initial_data)
      raise ArgumentError unless [Array, Integer].include?(initial_data.class)
    end

    def check_bit_index(bit_index)
      raise ArgumentError unless bit_index.is_a?(Integer)
      raise IndexError if bit_index.negative? || bit_index >= @bitsize
    end

    def check_bpi(bpi)
      raise ArgumentError unless [
        Bitary::BYTE,
        Bitary::SHORT,
        Bitary::INT,
        Bitary::LONG
      ].include?(bpi)
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
      if value > @bpi
        increase_items_size!(value)
      else
        decrease_items_size!(value)
      end
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
      offset = bpi
      mask = (2**new_size) - 1

      while offset.positive?
        offset -= new_size
        yield ((item >> offset) & mask)
      end
    end
  end
end
