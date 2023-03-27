# frozen_string_literal: true

require_relative '../lib/dependencies'

RSpec.shared_examples 'a queen' do |color, symbol|
  let(:board) { Board.new }
  let(:queen) { Queen.new(color) }
  let(:same_color_piece) { Piece.new(color, :piece, 'P') }
  let(:opposing_color_piece) { Piece.new(color == :white ? :black : :white, :piece, 'P') }

  describe '#initialize' do
    it 'creates a piece of the correct color' do
      expect(queen.color).to eq(color)
    end
    it 'creates a piece of the queen type' do
      expect(queen.type).to eq(:queen)
    end
    it 'prints the correct symbol' do
      expect(queen.to_s).to eq(symbol)
    end
  end

  describe '#same_color_as' do
    it 'returns true if a piece is of same color' do
      expect(queen.same_color_as(same_color_piece)).to be_truthy
    end
    it 'returns false if a piece is of different color' do
      expect(queen.same_color_as(opposing_color_piece)).to be_falsy
    end
  end

  describe '#possible_moves' do
    context 'when set to the middle of the board' do
      before do
        board.add_piece(queen, [4, 4])
      end
      context 'when there are no other pieces in the board' do
        it 'returns 27 possible moves' do
          expect(queen.possible_moves(board).size).to eq(27)
        end
        it 'returns the correct movement array' do
          expect(queen.possible_moves(board)).to contain_exactly(
            [5, 4], [6, 4], [7, 4], [3, 4], [2, 4], [1, 4], [0, 4], 
            [4, 5], [4, 6], [4, 7], [4, 3], [4, 2], [4, 1], [4, 0],
            [5, 5], [6, 6], [7, 7], [3, 3], [2, 2], [1, 1], [0, 0],
            [5, 3], [6, 2], [7, 1], [3, 5], [2, 6], [1, 7]
          )
        end
      end
      context 'when there are friendly pieces in the path' do
        context 'when the pieces are in the same column' do
          before do
            board.add_piece(same_color_piece, [0, 4])
            board.add_piece(same_color_piece, [6, 4])
          end

          it 'returns 24 possible moves' do
            expect(queen.possible_moves(board).size).to eq(24)
          end

          it 'returns the correct movement array' do
            expect(queen.possible_moves(board)).to contain_exactly(
              [0, 0], [1, 1], [1, 4], [1, 7], [2, 2], [2, 4],
              [2, 6], [3, 3], [3, 4], [3, 5], [4, 0], [4, 1],
              [4, 2], [4, 3], [4, 5], [4, 6], [4, 7], [5, 3],
              [5, 4], [5, 5], [6, 2], [6, 6], [7, 1], [7, 7]
            )
          end
        end
        context 'when the pieces are in the same row' do
          before do
            board.add_piece(same_color_piece, [4, 0])
            board.add_piece(same_color_piece, [4, 6])
          end

          it 'returns 24 possible moves' do
            expect(queen.possible_moves(board).size).to eq(24)
          end

          it 'returns the correct movement array' do
            expect(queen.possible_moves(board)).to contain_exactly(
              [0, 0], [0, 4], [1, 1], [1, 4], [1, 7], [2, 2],
              [2, 4], [2, 6], [3, 3], [3, 4], [3, 5], [4, 1],
              [4, 2], [4, 3], [4, 5], [5, 3], [5, 4], [5, 5],
              [6, 2], [6, 4], [6, 6], [7, 1], [7, 4], [7, 7]
            )
          end
        end
        context 'when the pieces are in the same diagonal' do
          before do
            board.add_piece(same_color_piece, [0, 0])
            board.add_piece(same_color_piece, [6, 6])
          end

          it 'returns 24 possible moves' do
            expect(queen.possible_moves(board).size).to eq(24)
          end

          it 'returns the correct movement array' do
            expect(queen.possible_moves(board)).to contain_exactly(
              [0, 4], [1, 1], [1, 4], [1, 7], [2, 2], [2, 4],
              [2, 6], [3, 3], [3, 4], [3, 5], [4, 0], [4, 1],
              [4, 2], [4, 3], [4, 5], [4, 6], [4, 7], [5, 3],
              [5, 4], [5, 5], [6, 2], [6, 4], [7, 1], [7, 4]
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

          it 'returns 26 possible moves' do
            expect(queen.possible_moves(board).size).to eq(26)
          end

          it 'returns the correct movement array' do
            expect(queen.possible_moves(board)).to contain_exactly(
              [0, 0], [0, 4], [1, 1], [1, 4], [1, 7], [2, 2],
              [2, 4], [2, 6], [3, 3], [3, 4], [3, 5], [4, 0],
              [4, 1], [4, 2], [4, 3], [4, 5], [4, 6], [4, 7],
              [5, 3], [5, 4], [5, 5], [6, 2], [6, 4], [6, 6],
              [7, 1], [7, 7]
            )
          end
        end
        context 'when the pieces are in the same row' do
          before do
            board.add_piece(opposing_color_piece, [4, 0])
            board.add_piece(opposing_color_piece, [4, 6])
          end

          it 'returns 26 possible moves' do
            expect(queen.possible_moves(board).size).to eq(26)
          end

          it 'returns the correct movement array' do
            expect(queen.possible_moves(board)).to contain_exactly(
              [0, 0], [0, 4], [1, 1], [1, 4], [1, 7], [2, 2],
              [2, 4], [2, 6], [3, 3], [3, 4], [3, 5], [4, 0],
              [4, 1], [4, 2], [4, 3], [4, 5], [4, 6], [5, 3],
              [5, 4], [5, 5], [6, 2], [6, 4], [6, 6], [7, 1],
              [7, 4], [7, 7]
            )
          end
        end
        context 'when the pieces are in the same diagonal' do
          before do
            board.add_piece(opposing_color_piece, [0, 0])
            board.add_piece(opposing_color_piece, [6, 6])
          end

          it 'returns 26 possible moves' do
            expect(queen.possible_moves(board).size).to eq(26)
          end

          it 'returns the correct movement array' do
            expect(queen.possible_moves(board)).to contain_exactly(
              [0, 0], [0, 4], [1, 1], [1, 4], [1, 7], [2, 2],
              [2, 4], [2, 6], [3, 3], [3, 4], [3, 5], [4, 0],
              [4, 1], [4, 2], [4, 3], [4, 5], [4, 6], [4, 7],
              [5, 3], [5, 4], [5, 5], [6, 2], [6, 4], [6, 6],
              [7, 1], [7, 4]
            )
          end
        end
      end
    end
  end
end

RSpec.describe Queen do
  describe 'white queen' do
    it_behaves_like 'a queen', :white, '♕'
  end

  describe 'black queen' do
    it_behaves_like 'a queen', :black, '♛'
  end
end