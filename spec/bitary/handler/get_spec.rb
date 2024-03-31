# frozen_string_literal: true

require 'bitary'

RSpec.describe Bitary::Handler::Get do
  describe '#execute' do
    before(:example) do
      @bit_getter = Bitary::Handler::Get.new(128)
    end

    it 'gets the bit at given index (starting from leftmost bit)' do
      expect(@bit_getter.execute(index: 0, size: 8)).to eq(1)
    end
  end
end
