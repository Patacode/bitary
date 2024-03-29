# frozen_string_literal: true

class Bitary
  class Deptainer
    def initialize
      @store = {}
    end

    def [](key)
      raise ArgumentError unless key.is_a?(Symbol)

      @store[key]
    end

    def []=(key, value)
      raise ArgumentError unless key.is_a?(Symbol)

      @store[key] = value
    end

    def has?(key)
      raise ArgumentError unless key.is_a?(Symbol)
      
      @store.has_key?(key)
    end
  end
end
