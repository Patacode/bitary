# frozen_string_literal: true

require 'bitary'

RSpec.describe Bitary::Handler::Unset do
  describe '#execute' do
    before(:example) do
      @bit_unsetter = Bitary::Handler::Unset.new(128)
    end

    it 'unsets the bit at given index to 0 (starting from leftmost bit)' do
      expect(@bit_unsetter.execute(index: 0, size: 8)).to eq(0)
    end
  end
end
