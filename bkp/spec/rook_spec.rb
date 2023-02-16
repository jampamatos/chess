# frozen_string_literal: true

require_relative '../lib/pieces/rook'
require_relative '../lib/pieces/pawn'
require_relative '../lib/board'

describe Rook do
  describe '#possible_moves' do
    let(:board) { Board.new }

    context 'when rook is in the middle of an empty board' do
      it 'returns all possible moves' do
        rook = Rook.new(:white)
        board.set_piece(rook, [3, 3])
        expected_moves = [[0, 3], [1, 3], [2, 3], [4, 3], [5, 3], [6, 3], [7, 3], [3, 0], [3, 1], [3, 2], [3, 4], [3, 5], [3, 6], [3, 7]]
        expect(rook.possible_moves(board, [3, 3])).to match_array(expected_moves)
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

        expected_moves = [[1, 3], [2, 3], [3, 2], [3, 4], [3, 5], [3, 6], [4, 3], [5, 3]]
        expect(rook.possible_moves(board, [3, 3])).to match_array(expected_moves)
      end
    end
  end

  describe '#move' do
    let(:board) { Board.new }

    context 'when destination is a valid move' do
      let(:rook) { Rook.new(:white) }

      before do
        board.set_piece(rook, [3, 3])
      end

      it 'updates position and returns chess notation of the move' do

        # Move the rook to a valid position
        expect(rook.move([3, 6], board).uncolorize).to eq("♖g5")

        # Check that the rook's position has been updated
        expect(rook.position).to eq([3, 6])
        expect(board[[3, 6]]).to eq(rook)

        # Check that the rook's previous position has been updated
        expect(board[[3, 3]]).to be_nil
      end

      it 'updates the @moved variable to true' do
        expect { rook.move([3, 6], board) }.to change { rook.instance_variable_get(:@moved) }.from(false).to(true)
      end
    end

    context 'when destination is not a valid move' do

      let(:rook) { Rook.new(:white) }

      before do
        board.set_piece(rook, [3, 3])
      end

      it 'throws error and does not update position' do
        # Try to move the rook to an invalid position
        expect { rook.move([5, 5], board) }.to raise_error(InvalidMoveError)

        # Check that the rook's position has not been updated
        expect(rook.position).to eq([3, 3])
      end
      it 'does not update the @moved variable to true' do
        expect { rook.move([5, 5], board) }.to raise_error(InvalidMoveError)
        expect(rook.instance_variable_get(:@moved)).to be_falsey
      end
    end

    context 'when destination is occupied by an enemy piece' do
      it 'captures the piece and returns chess notation of the move' do
        rook = Rook.new(:white)
        board.set_piece(rook, [3, 3])
        board.set_piece(Pawn.new(:black), [3, 6])

        # Move the rook to capture the black pawn
        expect(rook.move([3, 6], board).uncolorize).to eq("♖d5x♟g5")

        # Check that the rook's position has been updated
        expect(rook.position).to eq([3, 6])

        # Check that the black pawn has been removed from the board
        expect(board[[3, 6]]).to be rook
        expect(board[[3, 3]]).to be nil
        expect(board[[3, 6]]).to_not be_a(Pawn)
      end
    end

    context 'when destination is occupied by a friendly piece' do
      it 'raises an error and does not update position' do
        rook = Rook.new(:white)
        board.set_piece(rook, [3, 3])
        board.set_piece(Pawn.new(:white), [3, 6])

        # Try to move the rook to a square occupied by a friendly pawn
        expect { rook.move([3, 6], board) }.to raise_error(InvalidMoveError)

        # Check that the rook's position has not been updated
        expect(rook.position).to eq([3, 3])
      end
    end
  end
end

