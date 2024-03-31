# frozen_string_literal: true

require_relative 'handler/set'
require_relative 'handler/unset'
require_relative 'handler/get'
require_relative 'handler/append'

class Bitary
  class Handler
    attr_reader :value

    def initialize(value)
      @value = value
    end

    def execute(**kwargs)
      raise NotImplementedError
    end
  end
end
