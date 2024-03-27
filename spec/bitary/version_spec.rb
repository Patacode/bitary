# frozen_string_literal: true

require 'bitary/version'

RSpec.describe Bitary do
  describe '::VERSION' do
    it 'has a version number' do
      expect(Bitary::VERSION).not_to be nil
    end
  end
end
