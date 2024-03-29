# frozen_string_literal: true

class Bitary
  class Factory
    private_class_method :new
    @memo = {}

    def self.make(name, *, **)
      raise ArgumentError unless name.is_a?(String)

      name.split('::').reduce(Bitary) do |cls, str|
        cls.const_get(str)
      end.new(*, **)
    end

    def self.make_memo(name, *args, **kwargs)
      raise ArgumentError unless name.is_a?(String)
      if @memo.key?(name.to_sym) && !args.empty? && !kwargs.empty?
        raise ArgumentError
      end

      @memo[name.to_sym] ||= make(name, *args, **kwargs)
    end
  end
end
