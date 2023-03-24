# frozen_string_literal: true

require_relative '../lib/dependencies'

RSpec.describe Rook do
  let(:board) { Board.new }
  let(:white_rook) { Rook.new('white') }
  let(:black_rook) { Rook.new('black') }
  let(:white_piece1) { Piece.new('white', 'piece', 'P') }
  let(:white_piece2) { Piece.new('white', 'piece', 'P') }
  let(:black_piece1) { Piece.new('black', 'piece', 'P') }
  let(:black_piece2) { Piece.new('black', 'piece', 'P') }

  describe '#initialize' do
    context 'when creating a white rook' do
      it 'creates a piece of the white color' do
        expect(white_rook.color).to eq('white')
      end
      it 'creates a piece of the rook type' do
        expect(white_rook.type).to eq('rook')
      end
      it 'prints the correct symbol' do
        expect(white_rook.to_s).to eq('♖')
      end
    end
    context 'when creating a black rook' do
      it 'creates a piece of the black color' do
        expect(black_rook.color).to eq('black')
      end
      it 'creates a piece of the rook type' do
        expect(black_rook.type).to eq('rook')
      end
      it 'prints the correct symbol' do
        expect(black_rook.to_s).to eq('♜')
      end
    end
  end
end