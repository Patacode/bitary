# frozen_string_literal: true

class Bitary
  class Handler
    class Set < Bitary::Handler
      def execute(**kwargs)
        @value | (2**(kwargs[:size] - kwargs[:index] - 1))
      end
    end
  end
end
