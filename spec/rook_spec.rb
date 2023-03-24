# frozen_string_literal: true

require_relative '../lib/dependencies'

RSpec.shared_examples 'a rook' do |color, symbol|
  let(:board) { Board.new }
  let(:rook) { Rook.new(color) }
  let(:same_color_piece) { Piece.new(color, 'piece', 'P') }
  let(:opposing_color_piece) { Piece.new(color == 'white' ? 'black' : 'white', 'piece', 'P') }

  describe '#initialize' do
    it 'creates a piece of the correct color' do
      expect(rook.color).to eq(color)
    end
    it 'creates a piece of the rook type' do
      expect(rook.type).to eq('rook')
    end
    it 'prints the correct symbol' do
      expect(rook.to_s).to eq(symbol)
    end
  end

  describe '#same_color_as' do
    it 'returns true if a piece is of same color' do
      expect(rook.same_color_as(same_color_piece)).to be_truthy
    end
    it 'returns false if a piece is of different color' do
      expect(rook.same_color_as(opposing_color_piece)).to be_falsy
    end
  end

  describe '#possible_moves' do
    context 'when set to the middle of the board' do
      before do
        board.add_piece(rook, [4, 4])
      end
      context 'when there are no other pieces in the board' do
        it 'returns 14 possible moves' do
          expect(rook.possible_moves(board).size).to eq(14)
        end
        it 'returns the correct movement array' do
          expect(rook.possible_moves(board)).to contain_exactly(
            [5, 4], [6, 4], [7, 4], [3, 4], [2, 4], [1, 4], [0, 4], 
            [4, 5], [4, 6], [4, 7], [4, 3], [4, 2], [4, 1], [4, 0]
          )
        end
      end
      context 'when there are friendly pieces in the path' do
        context 'when the pieces are in the same column' do
          before do
            board.add_piece(same_color_piece, [0, 4])
            board.add_piece(same_color_piece, [6, 4])
          end

          it 'returns 11 possible moves' do
            expect(rook.possible_moves(board).size).to eq(11)
          end

          it 'returns the correct movement array' do
            expect(rook.possible_moves(board)).to contain_exactly(
              [5, 4], [3, 4], [2, 4], [1, 4], [4, 5], 
              [4, 6], [4, 7], [4, 3], [4, 2], [4, 1], [4, 0]
            )
          end
        end
        context 'when the pieces are in the same row' do
          before do
            board.add_piece(same_color_piece, [4, 0])
            board.add_piece(same_color_piece, [4, 6])
          end

          it 'returns 11 possible moves' do
            expect(rook.possible_moves(board).size).to eq(11)
          end

          it 'returns the correct movement array' do
            expect(rook.possible_moves(board)).to contain_exactly(
              [5, 4], [6, 4], [7, 4], [3, 4], [2, 4],
              [1, 4], [0, 4], [4, 5], [4, 3], [4, 2], [4, 1]
            )
          end
        end
      end
      context 'when there are opposing pieces in the path' do
        context 'when the pieces are in the same column' do
          before do
            board.add_piece(opposing_color_piece, [0, 4])
            board.add_piece(opposing_color_piece, [6, 4])
          end
    
          it 'returns 13 possible moves' do
            expect(rook.possible_moves(board).size).to eq(13)
          end
    
          it 'returns the correct movement array' do
            expect(rook.possible_moves(board)).to contain_exactly(
              [5, 4], [3, 4], [2, 4], [1, 4], [4, 5], 
              [4, 6], [4, 7], [4, 3], [4, 2], [4, 1], 
              [4, 0], [0, 4], [6, 4]
            )
          end
        end
        context 'when the pieces are in the same row' do
          before do
            board.add_piece(opposing_color_piece, [4, 0])
            board.add_piece(opposing_color_piece, [4, 6])
          end
    
          it 'returns 13 possible moves' do
            expect(rook.possible_moves(board).size).to eq(13)
          end
    
          it 'returns the correct movement array' do
            expect(rook.possible_moves(board)).to contain_exactly(
              [5, 4], [6, 4], [7, 4], [3, 4], [2, 4],
              [1, 4], [0, 4], [4, 5], [4, 3], [4, 2],
              [4, 1], [4, 0], [4, 6]
            )
          end
        end
      end
    end
  end
end

RSpec.describe Rook do
  describe 'white rook' do
    include_examples 'a rook', 'white', '♖'
  end

  describe 'black rook' do
    include_examples 'a rook', 'black', '♜'
  end
end