# frozen_string_literal: true

class Bitary
  class Handler
    class Unset < Bitary::Handler
      SPEC = {
        index: {
          required: true,
          type: Integer,
          predicate: {
            callback: lambda do |**kwargs|
              kwargs[:index] >= 0 && kwargs[:index] < kwargs[:size]
            end,
            error: IndexError
          }
        },
        size: {
          required: true,
          type: Integer
        }
      }.freeze

      def execute(**kwargs)
        mask =
          (2**kwargs[:size]) - 1 - (2**(kwargs[:size] - kwargs[:index] - 1))

        @value & mask
      end
    end
  end
end
