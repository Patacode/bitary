# frozen_string_literal: true

require_relative 'handler/set'
require_relative 'handler/unset'
require_relative 'handler/get'
require_relative 'handler/append'

class Bitary
  class Handler
    SPEC = {}.freeze

    attr_reader :value

    def self.new(*arg, **kwargs)
      Decorator::SingleMethod::KwargsValidator.new(
        super,
        { execute: self::SPEC }
      )
    end

    def initialize(value)
      raise ArgumentError unless value.is_a?(Integer)

      @value = value
    end

    def execute(**kwargs)
      raise NotImplementedError
    end
  end
end
