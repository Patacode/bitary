# frozen_string_literal: true

class Bitary
  class Handler
    class Append < Bitary::Handler
      def execute(**kwargs)
        raise ArgumentError unless kwargs.all? do |key, _value|
          %i[offset value].include?(key)
        end

        offset = kwargs[:offset] or raise KeyError
        value = kwargs[:value] or raise KeyError
        raise ArgumentError unless offset.is_a?(Integer)
        raise ArgumentError unless value.is_a?(Integer)

        (@value << offset) | value
      end
    end
  end
end
