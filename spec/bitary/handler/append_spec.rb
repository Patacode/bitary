# frozen_string_literal: true

require 'bitary'

RSpec.describe Bitary::Handler::Append do
  describe '#execute' do
    before(:example) do
      @bit_appender = Bitary::Handler::Append.new(128)
    end

    it 'gets the bit at given index (starting from leftmost bit)' do
      expect(@bit_appender.execute(offset: 4, value: 0b1111)).to eq(2_063)
    end
  end
end
