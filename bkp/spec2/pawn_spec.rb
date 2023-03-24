# frozen_string_literal: true

require_relative '../lib/dependencies'

RSpec.shared_examples 'a pawn' do |color, symbol, &block|
  let(:board) { Board.new }
  let(:pawn) { Pawn.new(color) }
  let(:same_color_piece) { Piece.new(color, :piece, 'P') }
  let(:opposing_color_piece) { Piece.new(color == :white ? :black : :white, :piece, 'P') }

  describe '#initialize' do
    it 'creates a piece of the correct color' do
      expect(pawn.color).to eq(color)
    end
    it 'creates a piece of the pawn type' do
      expect(pawn.type).to eq(:pawn)
    end
    it 'prints the correct symbol' do
      expect(pawn.to_s).to eq(symbol)
    end
  end

  describe '#same_color_as' do
    it 'returns true if a piece is of same color' do
      expect(pawn.same_color_as(same_color_piece)).to be_truthy
    end
    it 'returns false if a piece is of different color' do
      expect(pawn.same_color_as(opposing_color_piece)).to be_falsy
    end
  end

  describe '#possible_moves' do
    instance_exec(&block) if block_given?

    context 'when set to the middle of the board' do
      before do
        board.add_piece(pawn, [4, 4])
      end

      context 'when there are no other pieces in the board' do
        context 'when pawn has not moved yet' do
          it 'returns 2 possible moves' do
            expect(pawn.possible_moves(board).size).to eq(2)
          end

          it 'returns the correct movement array' do
            expect(pawn.possible_moves(board)).to contain_exactly(*two_moves)
          end
        end

        context 'when paw has moved' do
          before do
            pawn.mark_as_moved
          end

          it 'returns 1 possible move' do
            expect(pawn.possible_moves(board).size).to eq(1)
          end

          it 'returns the correct movement array' do
            expect(pawn.possible_moves(board)).to contain_exactly(*one_move)
          end
        end
      end
      context 'when there are friendly pieces in the path' do
        before do
          pawn.mark_as_moved
        end

        context 'when the piece is in front of the pawn' do
          before do
            board.add_piece(same_color_piece, *one_move)
          end

          it 'returns 0 possible moves' do
            expect(pawn.possible_moves(board).size).to eq(0)
          end
        end

        context 'when the piece is in the pawns diagonal' do
          before do
            board.add_piece(same_color_piece, *diagonal)
          end

          it 'returns 1 possible move' do
            expect(pawn.possible_moves(board).size).to eq(1)
          end

          it 'returns the correct movement array' do
            expect(pawn.possible_moves(board)).to contain_exactly(*one_move)
          end
        end
      end

      context 'when there are opposing pieces in the path' do
        before do
          pawn.mark_as_moved
        end

        context 'when the piece is in front of the pawn' do
          before do
            board.add_piece(opposing_color_piece, *one_move)
          end

          it 'returns 0 possible moves' do
            expect(pawn.possible_moves(board).size).to eq(0)
          end
        end

        context 'when the piece is in the pawns diagonal' do
          before do
            board.add_piece(opposing_color_piece, *diagonal)
          end

          it 'returns 1 possible move' do
            expect(pawn.possible_moves(board).size).to eq(1)
          end

          it 'returns the correct movement array' do
            expect(pawn.possible_moves(board)).to contain_exactly(*one_move)
          end
        end
      end
    end
  end
end

RSpec.describe Pawn do
  describe 'white pawn' do
    it_behaves_like 'a pawn', :white, '♙' do
      let(:two_moves) { [[3, 4], [2, 4]] }
      let(:one_move) { [[3, 4]] }
      let(:diagonal) { [[2, 3]] }
    end
  end

  describe 'black pawn' do
    it_behaves_like 'a pawn', :black, '♟︎' do
      let(:two_moves) { [[5, 4], [6, 4]] }
      let(:one_move) { [[5, 4]] }
      let(:diagonal) { [[6, 3]]}
    end
  end

  let(:board) { Board.new }
  let(:white_pawn) { Pawn.new(:white) }
  let(:black_pawn) { Pawn.new(:black) }

  describe '#possible_moves' do
    context 'when pawn can capture en passant' do
      before do
        board.add_piece(white_pawn, [6, 5])
        white_pawn.mark_as_moved
        board.add_piece(black_pawn, [4, 4])
        board.move_piece(black_pawn, [6, 4])
      end

      it 'returns 2 possible moves' do
        expect(white_pawn.possible_moves(board).size).to eq(2)
      end

      it 'returns the correct movement array' do
        expect(white_pawn.possible_moves(board)).to contain_exactly([5, 5], [5, 4])
      end

      context 'when pawn makes en passant capture' do
        before do
          board.move_piece(white_pawn, [5, 4])
        end

        it 'removes the captured pawn' do
          expect(board.piece_at([6, 4])).to be_nil
        end
      end
    end
  end
end
