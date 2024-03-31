# frozen_string_literal: true

class Bitary
  class Handler
    class Append < Bitary::Handler
      def execute(**kwargs)
        (@value << kwargs[:offset]) | kwargs[:value]
      end
    end
  end
end
