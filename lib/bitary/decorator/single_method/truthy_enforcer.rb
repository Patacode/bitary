# frozen_string_literal: true

class Bitary
  class Decorator
    class TruthyEnforcer < Bitary::Decorator::SingleMethod
      protected

      def postcall(resp)
        resp or raise TypeError
      end
    end
  end
end
