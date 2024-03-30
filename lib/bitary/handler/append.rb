# frozen_string_literal: true

class Bitary
  class Handler
    class Append < Bitary::Handler
      SPEC = {
        offset: {
          required: true,
          type: Integer
        },
        value: {
          required: true,
          type: Integer
        }
      }.freeze

      def execute(**kwargs)
        (@value << kwargs[:offset]) | kwargs[:value]
      end
    end
  end
end
