# frozen_string_literal: true

class Bitary
  class Handler
    class Unset < Bitary::Handler
      def execute(**kwargs)
        raise ArgumentError unless kwargs.none? { |key, _value| key != :index }

        index = kwargs[:index] or raise KeyError
        raise ArgumentError unless index.is_a?(Integer)

        bits = @value.bit_length
        raise IndexError if index.negative? || index >= bits

        @value & (((2**bits) - 1) - (2**bits - index - 1))
      end
    end
  end
end
