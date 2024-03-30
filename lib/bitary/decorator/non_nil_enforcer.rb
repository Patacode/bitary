# frozen_string_literal: true

class Bitary
  class Decorator
    class NonNilEnforcer < Bitary::Decorator
      def initialize(wrappee, method)
        super(wrappee) { |meth| meth == method }
        check_method(wrappee, method)
      end

      protected

      def postcall(resp)
        raise TypeError if resp.nil?

        resp
      end

      private

      def check_method(wrappee, method)
        raise ArgumentError unless method.is_a?(Symbol)
        raise NoMethodError unless wrappee.respond_to?(method)
      end
    end
  end
end
