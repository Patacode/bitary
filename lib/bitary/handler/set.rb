# frozen_string_literal: true

class Bitary
  class Handler
    class Set < Bitary::Handler
      def initialize(value)
        super
      end

      def execute(**kwargs)
        raise ArgumentError unless kwargs.none? { |key, value| key != :index }

        index = kwargs[:index] or raise KeyError

        bits = @value.bit_length
        raise IndexError if index < 0 || index >= bits

        @value | (2**(bits - index - 1))
      end
    end
  end
end
