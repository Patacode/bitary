# frozen_string_literal: true

require 'bitary/size'

RSpec.describe Bitary::Size do
  describe '::BYTE' do
    it 'defines a size of 8 bits' do
      expect(Bitary::Size::BYTE).to eq(8)
    end
  end

  describe '::SHORT' do
    it 'defines a size of 16 bits' do
      expect(Bitary::Size::SHORT).to eq(16)
    end
  end

  describe '::INT' do
    it 'defines a size of 32 bits' do
      expect(Bitary::Size::INT).to eq(32)
    end
  end

  describe '::LONG' do
    it 'defines a size of 64 bits' do
      expect(Bitary::Size::LONG).to eq(64)
    end
  end
end
