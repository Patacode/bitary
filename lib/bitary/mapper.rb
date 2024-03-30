# frozen_string_literal: true

require_relative 'mapper/int_to_bit'

class Bitary
  class Mapper
    def self.new(*arg, **kwargs)
      Decorator::NonNilEnforcer.new(super, :map)
    end

    def map(value)
      raise NotImplementedError
    end
  end
end
