# frozen_string_literal: true

require_relative '../lib/bishop'
require_relative '../lib/pawn'
require_relative '../lib/board'

RSpec.describe Bishop do
  describe Bishop do
    let(:board) { instance_double('Board') }
    let(:bishop) { Bishop.new(:white) }

    describe '#possible_moves' do
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
          allow(board).to receive(:[]).and_return(
            nil,
            instance_double('Piece', color: :black), # [4, 3]
            instance_double('Piece', color: :white), # [3, 4]
            nil, nil, nil, nil, nil, nil, nil, nil, nil, nil,
            instance_double('Piece', color: :white), # [2, 2]
            nil, nil, nil, nil, nil,
            instance_double('Piece', color: :black), # [2, 6]
            nil, nil, nil, nil, nil, nil, nil,
            instance_double('Piece', color: :black), # [6, 2]
            nil, nil, nil, nil, nil, nil, nil,
            instance_double('Piece', color: :white)  # [6, 6]
          )
        end
      
        it 'returns only the possible moves that do not capture a piece of the same color' do
          expect(bishop.possible_moves(board)).to contain_exactly([2, 2], [3, 3], [3, 5], [2, 6], [5, 3], [6, 2], [5, 5], [6, 6])
        end
      end
    end
  end
end