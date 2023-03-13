# frozen_string_literal: true

require_relative '../lib/pieces/knight'
require_relative '../lib/pieces/pawn'
require_relative '../lib/board'

RSpec.describe Knight do
  describe '#possible_moves' do
    let(:board) { Board.new }

    context 'when knight is in the center of the board' do
      let(:knight) { Knight.new(:white) }

      before do
        board.set_piece(knight, [3, 3])
      end

      it 'returns an array of 8 possible moves' do
        expected_moves = [[5, 4], [5, 2], [1, 4], [1, 2], [4, 5], [4, 1], [2, 5], [2, 1]]
        expect(knight.possible_moves(board)).to match_array(expected_moves)
      end

      it 'returns an array of 4 possible moves when some squares are occupied by friendly pieces' do
        board.set_piece(Pawn.new(:white), [4, 1])
        board.set_piece(Pawn.new(:white), [4, 5])
        board.set_piece(Pawn.new(:white), [2, 1])
        board.set_piece(Pawn.new(:white), [2, 5])
        expected_moves = [[5, 4], [5, 2], [1, 4], [1, 2]]
        expect(knight.possible_moves(board)).to match_array(expected_moves)
      end

      it 'returns an array of 8 possible moves when some squares are occupied by enemy pieces' do
        board.set_piece(Pawn.new(:black), [4, 1])
        board.set_piece(Pawn.new(:black), [4, 5])
        board.set_piece(Pawn.new(:black), [2, 1])
        board.set_piece(Pawn.new(:black), [2, 5])
        expected_moves = [[5, 4], [5, 2], [1, 4], [1, 2], [4, 5], [4, 1], [2, 5], [2, 1]]
        expect(knight.possible_moves(board)).to match_array(expected_moves)
      end
    end

    context 'when there are pieces in the way' do
      it 'can jump over them to reach its destination' do
        knight = Knight.new(:white)
        board.set_piece(knight, [3, 3])
        board.set_piece(Pawn.new(:white), [4, 3])
        board.set_piece(Pawn.new(:white), [2, 3])
        board.set_piece(Pawn.new(:white), [3, 4])
        board.set_piece(Pawn.new(:white), [3, 2])
        board.set_piece(Pawn.new(:white), [4, 4])
        board.set_piece(Pawn.new(:white), [2, 2])
        board.set_piece(Pawn.new(:white), [4, 2])
        board.set_piece(Pawn.new(:white), [2, 4])

        expect(knight.possible_moves(board)).to contain_exactly([1, 2], [1, 4], [2, 1], [2, 5], [4, 1], [4, 5], [5, 2], [5, 4])
      end
    end
  end

  describe '#move' do
    let(:board) { Board.new }

    context 'when destination is a valid move' do
      let(:knight) { Knight.new(:white) }

      before do
        board.set_piece(knight, [3, 3])
      end

      it 'moves to the destination and returns chess notation of the move' do
        expect(knight.move([5, 2], board).uncolorize).to eq('♘c3')
        expect(knight.position).to eq([5, 2])
        expect(board[[5, 2]]).to eq(knight)
        expect(board[[3, 3]]).to be_nil
      end

      it 'captures an enemy piece if present on destination' do
        black_knight = Knight.new(:black)
        board.set_piece(black_knight, [5, 2])
        expect(knight.move([5, 2], board).uncolorize).to eq('♘d5x♞c3')
        expect(board[[5, 2]]).to eq(knight)
        expect(board[[3, 3]]).to be_nil
      end
    end

    context 'when destination is an invalid move' do
      let(:knight) { Knight.new(:white) }

      before do
        board.set_piece(knight, [3, 3])
      end

      it 'does not move to the destination and throw error' do
        expect { knight.move([4, 4], board) }.to raise_error(InvalidMoveError)
        expect(board[[4, 4]]).to be_nil
      end
    end
  end
end
