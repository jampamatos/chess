# frozen_string_literal: true

require_relative '../lib/pieces/queen'
require_relative '../lib/pieces/pawn'
require_relative '../lib/board'

RSpec.describe Queen do
  describe '#possible_moves' do
    let(:board) { Board.new }
    let(:queen) { Queen.new(:white) }

    context 'when the queen is in the middle of the board' do
      before do
        board.set_piece(queen, [4, 4])
      end

      it 'returns 27 possible moves' do
        expect(queen.possible_moves(board).size).to eq 27
      end

      it 'returns all possible moves' do
        expect(queen.possible_moves(board)).to contain_exactly(
          [0, 0], [1, 1], [2, 2], [3, 3], [5, 5], [6, 6], [7, 7], [7, 1], [6, 2],
          [5, 3], [3, 5], [2, 6], [1, 7], [4, 0], [4, 1], [4, 2], [4, 3], [4, 5],
          [4, 6], [4, 7], [0, 4], [1, 4], [2, 4], [3, 4], [5, 4], [6, 4], [7, 4]
        )
      end
    end

    context 'when the queen is in the corner of the board' do
      before do
        board.set_piece(queen, [0, 0])
      end

      it 'returns 21 possible moves' do
        expect(queen.possible_moves(board).size).to eq 21
      end

      it 'returns all possible moves' do
        expect(queen.possible_moves(board)).to contain_exactly(
          [0, 1], [0, 2], [0, 3], [0, 4], [0, 5], [0, 6], [0, 7],
          [1, 0], [2, 0], [3, 0], [4, 0], [5, 0], [6, 0], [7, 0],
          [1, 1], [2, 2], [3, 3], [4, 4], [5, 5], [6, 6], [7, 7]
        )
      end
    end

    context 'when there are pieces of different colors on the board' do
      before do
        board.set_piece(queen, [4, 4])
        board.set_piece(Pawn.new(:black), [4, 3])
        board.set_piece(Pawn.new(:black), [3, 4])
        board.set_piece(Pawn.new(:black), [2, 2])
        board.set_piece(Pawn.new(:black), [2, 6])
        board.set_piece(Pawn.new(:black), [6, 2])
        board.set_piece(Pawn.new(:black), [6, 6])
      end

      it 'returns 10 possible moves' do
        expect(queen.possible_moves(board).size).to eq 16
      end

      it 'returns all possible moves' do
        expect(queen.possible_moves(board)).to contain_exactly(
          [4, 3], [4, 5], [4, 6], [4, 7],
          [3, 4], [5, 4], [6, 4], [7, 4],
          [2, 2], [3, 3], [5, 5], [6, 6],
          [6, 2], [5, 3], [3, 5], [2, 6]
        )
      end
    end
  end

  describe '#move' do
    let(:board) { Board.new }
    let(:queen) { Queen.new(:white) }

    context 'when destination square is empty' do
      it 'moves the queen to the destination square and returns the move notation' do
        board.set_piece(queen, [4, 4])
        expect(queen.move([5, 5], board).uncolorize).to eq('♕f3')
        expect(queen.position).to eq([5, 5])
        expect(board[[5, 5]]).to eq(queen)
        expect(board[[4, 4]]).to be_nil
      end
    end

    context 'when the destination square is occupied by a piece of the same color' do
      it 'raises an InvalidMoveError' do
        board.set_piece(queen, [4, 4])
        board.set_piece(Pawn.new(:white), [5, 5])
        expect { queen.move([5, 5], board) }.to raise_error(InvalidMoveError)
        expect(board[[4, 4]]).to eq(queen)
      end
    end

    context 'when the destination square is occupied by a piece of a different color' do
      it 'moves the queen to the destination square, captures the piece and returns the move notation' do
        board.set_piece(queen, [4, 4])
        board.set_piece(Pawn.new(:black), [5, 5])
        expect(queen.move([5, 5], board).uncolorize).to eq('♕e4x♟f3')
        expect(board[[5, 5]]).to eq(queen)
        expect(board[[4, 4]]).to be_nil
        expect(board[[5, 6]]).to be_nil
        end
    end
  end
end
