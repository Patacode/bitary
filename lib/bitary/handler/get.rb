# frozen_string_literal: true

class Bitary
  class Handler
    class Get < Bitary::Handler
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
        (@value >> (kwargs[:size] - kwargs[:index] - 1)) & 0x1
      end
    end
  end
end
