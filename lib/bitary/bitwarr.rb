# frozen_string_literal: true

class Bitary
  class Bitwarr
    attr_reader :size, :bpi

    def initialize(initial_data, bpi: Bitary::LONG)
      unless initial_data.is_a?(Array) || initial_data.is_a?(Integer)
        raise ArgumentError
      end
      raise ArgumentError unless bpi.is_a?(Integer)

      @bpi = bpi
      @size = init_size(initial_data)
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

    private

    def init_size(initial_data)
      initial_data.is_a?(Array) ? @bpi * initial_data.length : initial_data
    end

    def init_array(initial_data)
      if initial_data.is_a?(Array)
        initial_data.clone
      else
        [0] * (@size / @bpi.to_f).ceil
      end
    end
  end
end
