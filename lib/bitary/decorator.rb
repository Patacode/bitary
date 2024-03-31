# frozen_string_literal: true

require_relative 'decorator/single_method'

class Bitary
  class Decorator
    def initialize(wrappee, &proc)
      @wrappee = wrappee
      @predicate = proc || ->(_method) { true }
    end

    def method_missing(method, *, **, &)
      if @wrappee.respond_to?(method)
        if @predicate.call(method)
          args, kwargs = precall(method, *, **)
          resp = @wrappee.send(method, *args, **kwargs, &)
          postcall(resp)
        else
          @wrappee.send(method, *, **, &)
        end
      else
        super
      end
    end

    def respond_to_missing?(method, include_all = false)
      @wrappee.respond_to?(method, include_all) || super
    end

    def wrappee
      res = @wrappee
      res = res.wrappee while res.respond_to?(:wrappee)
      res
    end

    protected

    def precall(_method, *args, **kwargs)
      [args, kwargs]
    end

    def postcall(resp)
      resp
    end
  end
end
