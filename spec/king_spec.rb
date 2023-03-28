# frozen_string_literal: true

require_relative '../lib/dependencies'

RSpec.shared_examples 'a king' do |color, symbol|
  let(:board) { Board.new }
  let(:king) { King.new(color) }
  let(:same_color_piece) { Piece.new(color, :piece, 'P') }
  let(:opposing_color_piece) { Piece.new(color == :white ? :black : :white, :piece, 'P') }

  describe '#initialize' do
    it 'creates a piece of the correct color' do
      expect(king.color).to eq(color)
    end
    it 'creates a piece of the king type' do
      expect(king.type).to eq(:king)
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
            board.add_piece(opposing_color_piece, [2, 4])
            board.add_piece(opposing_color_piece, [6, 4])
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
        context 'when the pieces are in the same row' do
          before do
            board.add_piece(opposing_color_piece, [4, 3])
            board.add_piece(opposing_color_piece, [4, 6])
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

  describe 'check logic' do
    context 'put an uncheckec king into check' do
      it 'returns false first and then true' do
        expect(king.in_check?).to be_falsy
        king.mark_as_in_check
        expect(king.in_check?).to be_truthy
      end
    end

    context 'put a checked king into uncheck' do
      it 'returns true first and then false' do
        king.mark_as_in_check
        expect(king.in_check?).to be_truthy
        king.mark_as_not_in_check
        expect(king.in_check?).to be_falsy
      end
    end
  end

  describe '#special_moves' do
    context 'when set to the starting position' do
      before do
        board.set_up_board
      end

      context 'when king and rooks have not moved and no pieces are in between' do
        let(:king) { board.find_king(color) }

        it 'returns no special moves' do
          expect(king.special_moves(board)).to be_empty
        end
      end

      context 'when king has moved' do
        before do
          king.mark_as_moved
        end

        it 'returns no special moves' do
          expect(king.special_moves(board)).to be_empty
        end
      end
    end

    context 'when king is set for castling' do
      before do
        board.add_piece(king, [board.pieces_rank(king.color), 4])
        board.add_piece(Rook.new(king.color), [board.pieces_rank(king.color), 0])
        board.add_piece(Rook.new(king.color), [board.pieces_rank(king.color), 7])
      end

      context 'when king is not in check and no pieces are in between' do
        it 'returns 2 special moves' do
          expect(king.special_moves(board).size).to eq(2)
        end

        it 'returns the correct special moves array' do
          row = board.pieces_rank(king.color)
          expect(king.special_moves(board)).to contain_exactly(
            [row, 2], [row, 6]
          )
        end
      end

      context 'when king is in check' do
        before do
          king.mark_as_in_check
        end

        it 'returns no special moves' do
          expect(king.special_moves(board)).to be_empty
        end
      end

      context 'when there are pieces in between' do
        before do
          board.add_piece(Piece.new(king.color, 'piece', 'P'), [board.pieces_rank(king.color), 3])
        end

        it 'returns 1 special move' do
          expect(king.special_moves(board).size).to eq(1)
        end

        it 'returns the correct special moves array' do
          row = board.pieces_rank(king.color)
          expect(king.special_moves(board)).to contain_exactly([row, 6])
        end
      end
    end

    context 'when a king is set for castling but some of the squares are under attack' do
      before do
        board.add_piece(king, [board.pieces_rank(king.color), 4])
        board.add_piece(Rook.new(king.color), [board.pieces_rank(king.color), 0])
        board.add_piece(Rook.new(king.color), [board.pieces_rank(king.color), 7])
        board.add_piece(Queen.new(board.opposing_color(king.color)), [board.pieces_rank(:black), 2])
        board.add_piece(Rook.new(board.opposing_color(king.color)), [board.pieces_rank(:black), 5])
      end

      it 'returns no special moves' do
        expect(king.special_moves(board)).to be_empty
      end
    end
  end
end

RSpec.describe King do
  describe 'white king' do
    it_behaves_like 'a king', :white, '♔'
  end

  describe 'black king' do
    it_behaves_like 'a king', :black, '♚'
  end
end