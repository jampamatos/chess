# frozen_string_literal: true

require_relative '../lib/pieces/bishop'
require_relative '../lib/pieces/pawn'
require_relative '../lib/board'

RSpec.describe Bishop do
  describe '#possible_moves' do
    let(:board) { Board.new }
    let(:bishop) { Bishop.new(:white) }

    context 'when the bishop is in the middle of the board' do
      before do
        bishop.position = [4, 4]
        allow(board).to receive(:[]).and_return(nil)
      end

      it 'returns all possible moves for the bishop' do
        expect(bishop.possible_moves(board)).to contain_exactly(
          [0, 0], [1, 1], [1, 7], [2, 2], [2, 6], [3, 3], [3, 5], [5, 3], [5, 5], [6, 2], [6, 6], [7, 1], [7, 7]
        )
      end
    end

    context 'when the bishop is in the corner of the board' do
      before do
        bishop.position = [0, 0]
        allow(board).to receive(:[]).and_return(nil)
      end

      it 'returns all possible moves for the bishop' do
        expect(bishop.possible_moves(board)).to contain_exactly([1, 1], [2, 2], [3, 3], [4, 4], [5, 5], [6, 6], [7, 7])
      end
    end

    context 'when there are pieces of different colors on the board' do
      before do
        bishop.position = [4, 4]
      end

      it 'returns all the possible moves' do
        board.set_piece(Pawn.new(:black), [4, 3])
        board.set_piece(Pawn.new(:black), [3, 4])
        board.set_piece(Pawn.new(:black), [2, 2])
        board.set_piece(Pawn.new(:black), [2, 6])
        board.set_piece(Pawn.new(:black), [6, 2])
        board.set_piece(Pawn.new(:black), [6, 6])
        expect(bishop.possible_moves(board)).to contain_exactly([2, 2], [3, 3], [3, 5], [2, 6], [5, 3], [6, 2], [5, 5], [6, 6])
      end
    end
  end

  describe '#move' do
    let(:board) { Board.new }
    let(:bishop) { Bishop.new(:white) }
    
    context 'when the destination square is empty' do
      it 'moves the bishop to the destination square and returns the move notation' do
        board.set_piece(bishop, [4, 4])
        expect(bishop.move([5, 5], board).uncolorize).to eq('♗f3')
        expect(bishop.position).to eq([5, 5])
        expect(board[[5, 5]]).to eq(bishop)
        expect(board[[4, 4]]).to be_nil
      end
    end

    context 'when the destination square is not diagonal to the current position' do
      it 'raises an InvalidMoveError' do
        board.set_piece(bishop, [4, 4])
        expect { bishop.move([5, 4], board) }.to raise_error(InvalidMoveError)
        expect(board[[4, 4]]).to eq(bishop)
      end
    end

    context 'when the destination square is occupied by a piece of the same color' do
      it 'raises an InvalidMoveError' do
        board.set_piece(bishop, [4, 4])
        board.set_piece(Pawn.new(:white), [5, 5])
        expect { bishop.move([5, 5], board) }.to raise_error(InvalidMoveError)
        expect(board[[4, 4]]).to eq(bishop)
      end
    end

    context 'when the destination square is occupied by a piece of a different color' do
      it 'moves the bishop to the destination square and returns the move notation' do
        board.set_piece(bishop, [4, 4])
        board.set_piece(Pawn.new(:black), [5, 5])
        expect(bishop.move([5, 5], board).uncolorize).to eq('♗e4x♟f3')
        expect(board[[5, 5]]).to eq(bishop)
        expect(board[[4, 4]]).to be_nil
        expect(board[[5, 6]]).to be_nil
        end
    end
  end
end