# frozen_string_literal: true

class Bitary
  class Handler
    class Unset < Bitary::Handler
      def execute(**kwargs)
        size = kwargs[:size]
        index = kwargs[:index]
        @value & (2**size) - 1 - (2**(size - index - 1))
      end
    end
  end
end
