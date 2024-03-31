# frozen_string_literal: true

class Bitary
  class Handler
    class Get < Bitary::Handler
      def execute(**kwargs)
        (@value >> (kwargs[:size] - kwargs[:index] - 1)) & 0x1
      end
    end
  end
end
