# frozen_string_literal: true

class Bitary
  class Handler
    class Append < Bitary::Handler
      def execute(**kwargs)
        raise ArgumentError unless kwargs.all? do |key, _value|
          %i[value].include?(key)
        end

        value = kwargs[:value] or raise KeyError
        raise ArgumentError unless value.is_a?(Integer)

        bits = value.bit_length
        (@value << bits) | value
      end
    end
  end
end
