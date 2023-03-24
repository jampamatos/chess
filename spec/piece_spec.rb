# frozen_string_literal: true

require_relative '../lib/dependencies'

RSpec.describe Piece do
  let(:white_piece1) { Piece.new(:white, :piece, 'P') }
  let(:white_piece2) { Piece.new(:white, :piece, 'P') }
  let(:black_piece) { Piece.new(:black, :piece, 'P') }

  before do
    white_piece2.mark_as_moved
  end

  describe '#initialize' do
    it 'initializes a new piece' do
      expect(white_piece1).to be_a(Piece)
    end

    it 'initializes with a color' do
      expect(white_piece1.color).to eq(:white)
    end

    it 'initializes with a type' do
      expect(white_piece1.type).to eq(:piece)
    end

    it 'initializes with a symbol' do
      expect(white_piece1.symbol).to eq('P')
    end

    it 'initializes with an empty position' do
      expect(white_piece1.position).to be_nil
    end

    it 'initializes with a moved status of false' do
      expect(white_piece1.moved).to be false
    end
  end

  describe '#to_s' do
    it 'returns the colorized symbol' do
      expect(white_piece1.to_s).to eq('P'.colorize(:white))
      expect(black_piece.to_s).to eq('P'.colorize(:black))
    end
  end

  describe '#same_color_as' do
    it 'returns true if the color is the same' do
      expect(white_piece1.same_color_as(white_piece2)).to be true
    end

    it 'returns false if the color is different' do
      expect(white_piece1.same_color_as(black_piece)).to be false
    end
  end

  describe '#mark_as_moved' do
    it 'marks the piece as moved' do
      white_piece1.mark_as_moved
      expect(white_piece1.moved).to be true
    end
  end

  describe '#mark_as_not_moved' do
    it 'marks the piece as not moved' do
      white_piece1.mark_as_not_moved
      expect(white_piece1.moved).to be false
    end
  end
end
