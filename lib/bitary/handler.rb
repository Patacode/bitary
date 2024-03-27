# frozen_string_literal: true

class Bitary
  class Handler
    def initialize(value)
      raise ArgumentError unless value.is_a?(Integer)

      @value = value
    end

    def execute(**kwargs)
      raise NotImplementedError
    end
  end
end
