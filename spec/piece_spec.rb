# frozen_string_literal: true

require_relative '../lib/piece'

describe Piece do
  describe '#initialize' do
    context 'when initializing a piece' do
      let(:piece) { Piece.new(:white, :rook, '♖', [0, 0]) }

      it 'sets the color attribute' do
        expect(piece.instance_variable_get(:@color)).to eq(:white)
      end

      it 'sets the type attribute' do
        expect(piece.instance_variable_get(:@type)).to eq(:rook)
      end

      it 'sets the position attribute' do
        expect(piece.instance_variable_get(:@position)).to eq([0, 0])
      end

      it 'sets the symbol attribute' do
        expect(piece.instance_variable_get(:@symbol)).to eq('♖')
      end
    end
  end

  describe '#to_s' do
    context 'when getting the symbol of a white piece' do
      let(:piece) { Piece.new(:white, :rook, '♖', [0, 0]) }

      it 'returns the correct symbol in white' do
        expect(piece.to_s).to eq("\e[0;37;49m♖\e[0m")
        puts piece
      end
    end

    context 'when getting the symbol of a black piece' do
      let(:piece) { Piece.new('white', :rook, '♖', [0, 0]) }

      it 'returns the correct symbol in black' do
        expect(piece.to_s).to eq('♖'.colorize('white'))
        puts piece
      end
    end
  end
  
end
