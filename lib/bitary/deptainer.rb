# frozen_string_literal: true

class Bitary
  class Deptainer
    def initialize
      @store = {}
    end

    def [](key)
      raise ArgumentError unless key.is_a?(Symbol)

      @store.fetch(key)
    end

    def []=(key, value)
      raise ArgumentError unless key.is_a?(Symbol)

      @store[key] = value
    end
  end
end
