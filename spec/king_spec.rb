# frozen_string_literal: true

require_relative '../lib/dependencies'

RSpec.shared_examples 'a king' do |color, symbol|
  let(:board) { Board.new }
  let(:king) { King.new(color) }
  let(:same_color_piece) { Piece.new(color, 'piece', 'P') }
  let(:opposing_color_piece) { Piece.new(color == 'white' ? 'black' : 'white', 'piece', 'P') }

  describe '#initialize' do
    it 'creates a piece of the correct color' do
      expect(king.color).to eq(color)
    end
    it 'creates a piece of the king type' do
      expect(king.type).to eq('king')
    end
    it 'prints the correct symbol' do
      expect(king.to_s).to eq(symbol)
    end
  end

  describe '#same_color_as' do
    it 'returns true if a piece is of same color' do
      expect(king.same_color_as(same_color_piece)).to be_truthy
    end
    it 'returns false if a piece is of different color' do
      expect(king.same_color_as(opposing_color_piece)).to be_falsy
    end
  end

  describe '#possible_moves' do
    context 'when set to the middle of the board' do
      before do
        board.add_piece(king, [4, 4])
      end
      context 'when there are no other pieces in the board' do
        it 'returns 8 possible moves' do
          expect(king.possible_moves(board).size).to eq(8)
        end
        it 'returns the correct movement array' do
          expect(king.possible_moves(board)).to contain_exactly(
            [5, 4], [3, 4], [4, 5], [4, 3], [5, 5], [3, 3], [5, 3], [3, 5]
          )
        end
      end
      context 'when there are friendly pieces in the path' do
        context 'when the pieces are in the same column' do
          before do
            board.add_piece(same_color_piece, [3, 4])
            board.add_piece(same_color_piece, [5, 4])
          end

          it 'returns 6 possible moves' do
            expect(king.possible_moves(board).size).to eq(6)
          end

          it 'returns the correct movement array' do
            expect(king.possible_moves(board)).to contain_exactly(
              [3, 5], [4, 5], [4, 3], [5, 5], [3, 3], [5, 3]
            )
          end
        end
        context 'when the pieces are in the same row' do
          before do
            board.add_piece(same_color_piece, [4, 3])
            board.add_piece(same_color_piece, [4, 5])
          end

          it 'returns 6 possible moves' do
            expect(king.possible_moves(board).size).to eq(6)
          end

          it 'returns the correct movement array' do
            expect(king.possible_moves(board)).to contain_exactly(
              [3, 3], [3, 4], [3, 5], [5, 3], [5, 4], [5, 5]
            )
          end
        end
        context 'when the pieces are in the same diagonal' do
          before do
            board.add_piece same_color_piece, [3, 3]
            board.add_piece same_color_piece, [5, 5]
          end

          it 'returns 6 possible moves' do
            expect(king.possible_moves(board).size).to eq(6)
          end

          it 'returns the correct movement array' do
            expect(king.possible_moves(board)).to contain_exactly(
              [3, 4], [3, 5], [4, 3], [4, 5], [5, 3], [5, 4]
            )
          end
        end
      end
      context 'when there are opposing pieces in the path' do
        context 'when the pieces are in the same column' do
          before do
            board.add_piece(opposing_color_piece, [3, 4])
            board.add_piece(opposing_color_piece, [5, 4])
          end

          it 'returns 6 possible moves' do
            expect(king.possible_moves(board).size).to eq(8)
          end

          it 'returns the correct movement array' do
            expect(king.possible_moves(board)).to contain_exactly(
              [3, 3], [3, 4], [3, 5], [4, 3], [4, 5], [5, 3], [5, 4], [5, 5]
            )
          end
        end
        context 'when the pieces are in the same row' do
          before do
            board.add_piece(opposing_color_piece, [4, 3])
            board.add_piece(opposing_color_piece, [4, 5])
          end

          it 'returns 8 possible moves' do
            expect(king.possible_moves(board).size).to eq(8)
          end

          it 'returns the correct movement array' do
            expect(king.possible_moves(board)).to contain_exactly(
              [3, 3], [3, 4], [3, 5], [4, 3], [4, 5], [5, 3], [5, 4], [5, 5]
            )
          end
        end
        context 'when the pieces are in the same diagonal' do
          before do
            board.add_piece(opposing_color_piece, [3, 3])
            board.add_piece(opposing_color_piece, [5, 5])
          end

          it 'returns 8 possible moves' do
            expect(king.possible_moves(board).size).to eq(8)
          end

          it 'returns the correct movement array' do
            expect(king.possible_moves(board)).to contain_exactly(
              [3, 3], [3, 4], [3, 5], [4, 3], [4, 5], [5, 3], [5, 4], [5, 5]
            )
          end
        end
      end
    end
  end
end

RSpec.describe King do
  describe 'white king' do
    it_behaves_like 'a king', 'white', '♔'
  end

  describe 'black king' do
    it_behaves_like 'a king', 'black', '♚'
  end
end