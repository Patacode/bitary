# frozen_string_literal: true

class Bitary
  class Decorator
    def initialize(wrappee, &proc)
      @wrappee = wrappee
      @predicate = proc || ->(method) { true }
    end

    def method_missing(method, *, **, &)
      if @wrappee.respond_to?(method) && @predicate.call(method)
        args, kwargs = precall(method, *, **)
        resp = @wrappee.send(method, *args, **kwargs, &)
        postcall(resp)
      else
        super
      end
    end

    def respond_to_missing?(method, include_all = false)
      wrappee_can_be_called = @wrappee.respond_to?(method, include_all)
      wrappee_can_be_called && @predicate.call(method) || super
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
