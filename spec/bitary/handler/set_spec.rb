# frozen_string_literal: true

require 'bitary'

RSpec.describe Bitary::Handler::Set do
  describe '#execute' do
    before(:example) do
      @bit_setter = Bitary::Handler::Set.new(128)
    end

    it 'sets the bit at given index to 1 (starting from leftmost bit)' do
      expect(@bit_setter.execute(index: 1, size: 8)).to eq(192)
    end
  end
end
