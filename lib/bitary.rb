# frozen_string_literal: true

require_relative 'bitary/size'
require_relative 'bitary/version'
require_relative 'bitary/bitwarr'

# Bit array facade through client code SHOULD interact with.
class Bitary
  include Size

  # Creates a new bit array.
  #
  # If the initial bit capacity is not given (or `nil`), it will be deducted
  # from the given byte array. In such case, if no byte array is given, it
  # will default to {Bitwarr::DEFAULT_INIT_CAP}.
  #
  # If no byte array is given (or `nil`), the resulting bit array's items will
  # all be set to 0.
  #
  # Note that, no check is performed on the byte array parameter to ensure
  # that it has `Integer` items only, as it would considerably impact the
  # data structure performance at initialization time. So be careful with
  # it.
  #
  # @param init_cap [Integer?] an optional initial bit capacity
  # @param bytes [Array<Integer>?] an optional byte array used to preset
  #   the bit array
  # @param bpi [Integer] the number of bits used per item internally.
  #   Defaults to {LONG}
  #
  # @raise [TypeError] if **init_cap** is neither an `Integer` nor `nil`
  # @raise [TypeError] if **bytes** is neither an `Array` nor `nil`
  # @raise [TypeError] if **bpi** is not an `Integer`
  # @raise [ArgumentError] if **init_cap** is <= 0
  # @raise [ArgumentError] if **bpi** is not equal to one of the constants
  #   defined in {Size}
  def initialize(init_cap = nil, bytes: nil, bpi: LONG)
    check_init_cap(init_cap)
    check_bytes(bytes)
    check_bpi(bpi)

    @bitwarr = Bitwarr.new(init_cap, bytes:, bpi:)
  end

  # Gets the bit at given index.
  #
  # @param index [Integer] the index of the bit to retrieve
  #
  # @raise [TypeError] if **index** is not an `Integer`
  # @raise [IndexError] if **index** is < 0 || >= {#bits}
  #
  # @return [Integer] the bit at given index
  def [](index)
    check_bit_index(index)

    @bitwarr.bit_at(index)
  end

  # Sets or unsets the bit at given index.
  #
  # The bit at given index will be set to 1 if given value is truthy but 0,
  # or 0 otherwise.
  #
  # @param index [Integer] the index of the bit to set/unset
  # @param value [Object] the object used to set/unset the bit at given index
  #
  # @raise [TypeError] if **index** is not an `Integer`
  # @raise [IndexError] if **index** is < 0 || >= {#bits}
  #
  # @return [Object] the given **value**
  def []=(index, value)
    check_bit_index(index)

    case obj_to_bit(value)
    when 0 then @bitwarr.unbit_at!(index)
    else @bitwarr.bit_at!(index)
    end
  end

  # Sets the bit at given index to 1 (set).
  #
  # Specialization method of {#[]=} that is similar to `bitary[index] = 1`.
  #
  # @param index [Integer] the index of the bit to set
  #
  # @raise [TypeError] if **index** is not an `Integer`
  # @raise [IndexError] if **index** is < 0 || >= {#bits}
  #
  # @return [Integer] 1
  def set!(index)
    self[index] = 1
  end

  # Sets the bit at given index to 0 (unset).
  #
  # Specialization method of {#[]=} that is similar to `bitary[index] = 0`.
  #
  # @param index [Integer] the index of the bit to unset
  #
  # @raise [TypeError] if **index** is not an `Integer`
  # @raise [IndexError] if **index** is < 0 || >= {#bits}
  #
  # @return [Integer] 0
  def unset!(index)
    self[index] = 0
  end

  # Traverses each byte of this bit array starting with its byte at most
  # significant address.
  #
  # @param block [Proc] the block to execute during byte traversal
  #
  # @yield [Integer] each byte of this bit array
  #
  # @return [Array<Integer>] a clone of the internal backed array (same
  #   as {#to_a})
  def each_byte(&block)
    @bitwarr.each_byte(&block)
  end

  # Returns a clone of the internal backed array used by this bit array.
  #
  # @return [Array<Integer>] a clone of the internal backed array
  def to_a
    @bitwarr.to_a
  end

  # Converts this bit array into an equivalent binary string.
  #
  # @return [String] the binary string representation of this bit array
  def to_s
    @bitwarr.to_s
  end

  # Updates the number of bits used internally by each item.
  #
  # Depending on the use case, increasing/decreasing the number of bits used
  # per item could reduce the memory footprint of this bit array.
  #
  # The idea is just to pay attention to potential internal fragmentation
  # and find the right balance between the total number of bits you want to
  # use and the number of bits that will be used by each item internally.
  #
  # @param value [Integer] the new bpi to be used by this bit array
  #
  # @raise [TypeError] if **value** is not an `Integer`
  # @raise [ArgumentError] if **value** is not equal to one of the constants
  #   defined in {Size}
  def bpi=(value)
    check_bpi(value)

    @bitwarr.bpi = value
  end

  # Returns the total number of bits used by this bit array.
  #
  # @return [Integer] he total number of bits used by this bit array
  def bits
    @bitwarr.bits
  end

  # Returns the number of bits used per item internally.
  #
  # @return [Integer] the number of bits used per item internally
  def bpi
    @bitwarr.bpi
  end

  private

  def check_init_cap(init_cap)
    return if init_cap.nil?

    raise TypeError unless init_cap.is_a?(Integer)
    raise ArgumentError unless init_cap.positive?
  end

  def check_bytes(bytes)
    return if bytes.nil?

    raise TypeError unless bytes.is_a?(Array)
  end

  def check_bpi(bpi)
    raise TypeError unless bpi.is_a?(Integer)
    raise ArgumentError unless [BYTE, SHORT, INT, LONG].include?(bpi)
  end

  def check_bit_index(bit_index)
    raise TypeError unless bit_index.is_a?(Integer)
    raise IndexError if bit_index.negative? || bit_index >= bits
  end

  def obj_to_bit(value)
    !!value ? truthy_to_bit(value) : 0
  end

  def truthy_to_bit(value)
    value.is_a?(Integer) ? int_to_bit(value) : 1
  end

  def int_to_bit(value)
    value.zero? ? 0 : 1
  end

  alias at []
end
