# frozen_string_literal: true

class Bitary
  class Decorator
    class KwargsValidator < Bitary::Decorator
      SPEC_KEYS = %i[required default type predicate].freeze

      def initialize(wrappee, spec)
        super(wrappee) { |method| spec.key?(method) }
        @spec = check_spec(@wrappee, spec)
      end

      protected

      def precall(method, *, **)
        super method, *, **check_kwargs(@spec, method, **)
      end

      private

      def check_spec(wrappee, spec)
        raise ArgumentError unless spec.is_a?(Hash)

        spec.each do |method, method_spec|
          check_spec_method(wrappee, method)
          check_spec_method_value(method_spec)
        end
      end

      def check_kwargs(spec, method, **kwargs)
        check_unexpected_user_kwargs(kwargs, spec[method])
        check_kwargs_against_spec(kwargs, spec[method])
      end

      def check_spec_method(wrappee, method)
        raise ArgumentError unless wrappee.respond_to?(method)
      end

      def check_spec_method_value(method_spec)
        raise ArgumentError unless method_spec.is_a?(Hash)
        method_spec.values.each do |arg_spec|
          raise ArgumentError unless arg_spec.is_a?(Hash)
          check_arg_spec(arg_spec)
        end
      end

      def check_arg_spec(arg_spec)
        raise ArgumentError unless arg_spec.keys.all? do |spec_key|
          SPEC_KEYS.include?(spec_key)
        end

        arg_spec.each do |spec_key, spec_value|
          check_arg_spec_entry(spec_key, spec_value)
        end

        if arg_spec.key?(:required) && arg_spec[:required]
          raise ArgumentError if arg_spec.key?(:default)
        end
      end

      def check_arg_spec_entry(key, value)
        case key
        when :required then check_required(value)
        when :default then check_default(value)
        when :type then check_type(value)
        when :predicate then check_predicate(value)
        end
      end

      def check_required(value)
        raise ArgumentError unless value == true || value == false
      end

      def check_default(value)
        raise ArgumentError if false
      end

      def check_type(value)
        raise ArgumentError unless value.is_a?(Class)
      end

      def check_predicate(value)
        available_keys = %i[callback error]
        raise ArgumentError unless value.is_a?(Hash)
        raise ArgumentError unless value.keys.all? do |key|
          available_keys.include?(key)
        end
        raise KeyError unless value.key?(:callback) && value.key?(:error)
        raise ArgumentError unless value[:callback].is_a?(Proc)
        raise ArgumentError unless value[:error].is_a?(Class)
        raise ArgumentError unless value[:error] < Exception
      end

      def check_unexpected_user_kwargs(user_kwargs, method_spec)
        raise ArgumentError unless user_kwargs.keys.all? do |key|
          method_spec.include?(key)
        end
      end

      def check_kwargs_against_spec(user_kwargs, method_spec)
        method_spec.reduce({}) do |acc, entry|
          kwarg_name, kwarg_spec = entry
          loaded_spec = load_spec(kwarg_spec)

          validate_required(user_kwargs, loaded_spec, kwarg_name)
          validate_type(user_kwargs, loaded_spec, kwarg_name)
          validate_predicate(user_kwargs, loaded_spec, kwarg_name)

          value =
            if user_kwargs.key?(kwarg_name)
              user_kwargs[kwarg_name]
            else
              loaded_spec[:default]
            end
          acc.merge(kwarg_name => value)
        end
      end

      def load_spec(kwarg_spec)
        {
          required: kwarg_spec[:required] || false,
          default: kwarg_spec[:default],
          type: kwarg_spec[:type] || Object,
          predicate: kwarg_spec[:predicate] || {
            callback: ->(_value) { true },
            error: ArgumentError
          }
        }
      end

      def validate_required(user_kwargs, spec, expected_key)
        if spec[:required]
          raise ArgumentError unless user_kwargs.key?(expected_key)
        end
      end

      def validate_type(user_kwargs, spec, expected_key)
        if user_kwargs.key?(expected_key)
          raise ArgumentError unless user_kwargs[expected_key].is_a?(
            spec[:type]
          )
        end
      end

      def validate_predicate(user_kwargs, spec, expected_key)
        if user_kwargs.key?(expected_key)
          unless spec[:predicate][:callback].call(user_kwargs[expected_key])
            raise spec[:predicate][:error]
          end
        end
      end
    end
  end
end
