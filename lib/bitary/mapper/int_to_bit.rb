# frozen_string_literal: true

class Bitary
  class Mapper
    class IntToBit < Bitary::Mapper
      def map(value)
        if value.is_a?(Integer)
          value.zero? ? 0 : 1
        else
          1
        end
      end
    end
  end
end
