# frozen_string_literal: true

class Bitary
  class Bitwarr
    attr_reader :bpi

    def initialize(initial_data, bpi: Bitary::LONG)
      unless initial_data.is_a?(Array) || initial_data.is_a?(Integer)
        raise ArgumentError
      end
      raise ArgumentError unless bpi.is_a?(Integer)

      @bpi = bpi
      @bitsize = init_bitsize(initial_data)
      @array = init_array(initial_data)
    end

    def method_missing(method, *, &)
      @array.respond_to?(method) ? @array.send(method, *, &) : super
    end

    def respond_to_missing?(method, include_all = false)
      @array.respond_to?(method, include_all) || super
    end

    def bpi=(value)
      raise ArgumentError unless value.is_a?(Integer)

      @bpi = value
    end

    def bitsize(bit_index = nil)
      if bit_index.nil?
        @bitsize
      else
        check_bit_index(bit_index)

        last_index = @array.length - 1
        if item_index(bit_index) == last_index
          @bitsize - (last_index * @bpi)
        else
          @bpi
        end
      end
    end

    def [](bit_index)
      @array[item_index(bit_index)]
    end

    def []=(bit_index, value)
      raise ArgumentError unless value.is_a?(Integer)

      @array[item_index(bit_index)] = value
    end

    def relative_bit_index(bit_index)
      check_bit_index(bit_index)

      bit_index % @bpi
    end

    def item_index(bit_index)
      check_bit_index(bit_index)

      bit_index / @bpi
    end

    private

    def init_bitsize(initial_data)
      initial_data.is_a?(Array) ? @bpi * initial_data.length : initial_data
    end

    def init_array(initial_data)
      if initial_data.is_a?(Array)
        initial_data.clone
      else
        [0] * (@bitsize / @bpi.to_f).ceil
      end
    end

    def check_bit_index(bit_index)
      raise ArgumentError unless bit_index.is_a?(Integer)
      raise IndexError if bit_index.negative? || bit_index >= @bitsize
    end
  end
end