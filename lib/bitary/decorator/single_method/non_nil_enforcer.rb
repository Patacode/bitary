# frozen_string_literal: true

class Bitary
  class Decorator
    class NonNilEnforcer < Bitary::Decorator::SingleMethod
      protected

      def postcall(resp)
        (resp.nil? and raise TypeError) || resp
      end
    end
  end
end
