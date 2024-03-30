# frozen_string_literal: true

require 'bitary'

RSpec.describe Bitary::Size do
  it 'has BYTE constant referring to size of 8 bits' do
    expect(Bitary::Size::BYTE).to eq(8)
  end

  it 'has SHORT constant referring to size of 16 bits' do
    expect(Bitary::Size::SHORT).to eq(16)
  end

  it 'has INT constant referring to size of 32 bits' do
    expect(Bitary::Size::INT).to eq(32)
  end

  it 'has LONG constant referring to size of 64 bits' do
    expect(Bitary::Size::LONG).to eq(64)
  end
end
