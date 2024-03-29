# frozen_string_literal: true

require_relative 'deptainer'

class Bitary
  class Factory
    private_class_method :new
    @container = Deptainer.new

    def self.make(name, *args, **kwargs)
      raise ArgumentError unless name.is_a?(String)

      name.split('::').reduce(Bitary) do |cls, str|
        cls.const_get(str)
      end.new(*args, **kwargs)
    end

    def self.make_memo(name, *args, **kwargs)
      raise ArgumentError unless name.is_a?(String)
      if @container.has?(name.to_sym) && !args.empty? && !kwargs.empty?
        raise ArgumentError
      end

      @container[name.to_sym] ||= make(name, *args, **kwargs)
    end
  end
end