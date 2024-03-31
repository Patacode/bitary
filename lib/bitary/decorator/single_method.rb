# frozen_string_literal: true

require_relative 'single_method/non_nil_enforcer'
require_relative 'single_method/truthy_enforcer'

class Bitary
  class Decorator
    class SingleMethod < Bitary::Decorator
      def initialize(wrappee, method)
        super(wrappee) { |meth| meth == method }
        check_method(wrappee, method)
      end

      private

      def check_method(wrappee, method)
        raise ArgumentError unless method.is_a?(Symbol)
        raise NoMethodError unless wrappee.respond_to?(method)
      end
    end
  end
end
