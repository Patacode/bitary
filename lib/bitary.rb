# frozen_string_literal: true

require_relative 'bitary/size'
require_relative 'bitary/version'
require_relative 'bitary/handler'
require_relative 'bitary/factory'
require_relative 'bitary/bitwarr'
require_relative 'bitary/decorator'
require_relative 'bitary/mapper'

class Bitary
  include Size

  def initialize(initial_data, bpi: LONG)
    @internal_array = Bitwarr.new(initial_data, bpi:)
  end

  def [](index)
    @internal_array.bit_at(index)
  end

  def []=(index, value)
    case Mapper::ObjToBit.new.map(value)
    when 0 then @internal_array.unbit_at!(index)
    else @internal_array.bit_at!(index)
    end
  end

  def set(index)
    self[index] = 1
  end

  def unset(index)
    self[index] = 0
  end

  def each_byte(&)
    @internal_array.each_byte(&)
  end

  def to_a
    @internal_array.to_a
  end

  def to_s
    @internal_array.to_s
  end

  def bpi=(value)
    @internal_array.bpi = value
  end

  def size
    @internal_array.bitsize
  end

  def bpi
    @internal_array.bpi
  end

  alias at []
end
