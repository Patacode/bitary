# frozen_string_literal: true

class Bitary
  class Handler
    class Unset < Bitary::Handler
      def execute(**kwargs)
        raise ArgumentError unless kwargs.all? do |key, _value|
          %i[index size].include?(key)
        end

        index = kwargs[:index] or raise KeyError
        size = kwargs[:size] or raise KeyError
        raise ArgumentError unless index.is_a?(Integer)
        raise ArgumentError unless size.is_a?(Integer)

        raise IndexError if index.negative? || index >= size

        @value & (((2**size) - 1) - (2**(size - index - 1)))
      end
    end
  end
end
