# frozen_string_literal: true

require_relative '../lib/rook'
require_relative '../lib/pawn'
require_relative '../lib/board'

describe Rook do
  describe '#possible_moves' do
    let(:board) { Board.new }

    context 'when rook is in the middle of an empty board' do
      it 'returns all possible moves' do
        rook = Rook.new(:white)
        board.set_piece(rook, [3, 3])
        expected_moves = [[0, 3], [1, 3], [2, 3], [4, 3], [5, 3], [6, 3], [7, 3], [3, 0], [3, 1], [3, 2], [3, 4], [3, 5], [3, 6], [3, 7]]
        expect(rook.possible_moves([3, 3], board)).to match_array(expected_moves)
      end
    end

    context 'when rook is blocked by other pieces' do
      it 'returns only moves that are not blocked' do
        rook = Rook.new(:white)
        board.set_piece(rook, [3, 3])

        # Block some moves with other pieces
        board.set_piece(Pawn.new(:white), [3, 1])
        board.set_piece(Pawn.new(:black), [3, 6])
        board.set_piece(Pawn.new(:black), [1, 3])
        board.set_piece(Pawn.new(:white), [6, 3])
        board.draw_board

        expected_moves = [[0, 3], [2, 3], [3, 0], [3, 2], [3, 4], [3, 5], [3, 7], [4, 3], [5, 3], [7, 3]]
        expect(rook.possible_moves([3, 3], board)).to match_array(expected_moves)
      end
    end
  end
end

