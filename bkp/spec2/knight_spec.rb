# frozen_string_literal: true

require_relative '../lib/dependencies'

RSpec.shared_examples 'a knight' do |color, symbol|
  let(:board) { Board.new }
  let(:knight) { Knight.new(color) }
  let(:same_color_piece) { Piece.new(color, :piece, 'P') }
  let(:opposing_color_piece) { Piece.new(color == :white ? :black : :white, :piece, 'P') }

  describe '#initialize' do
    it 'creates a piece of the correct color' do
      expect(knight.color).to eq(color)
    end
    it 'creates a piece of the knight type' do
      expect(knight.type).to eq(:knight)
    end
    it 'prints the correct symbol' do
      expect(knight.to_s).to eq(symbol)
    end
  end

  describe '#same_color_as' do
    it 'returns true if a piece is of same color' do
      expect(knight.same_color_as(same_color_piece)).to be_truthy
    end
    it 'returns false if a piece is of different color' do
      expect(knight.same_color_as(opposing_color_piece)).to be_falsy
    end
  end

  describe '#possible_moves' do
    context 'when set to the middle of the board' do
      before do
        board.add_piece(knight, [4, 4])
      end

      context 'when there are no other pieces in the board' do
        it 'returns 8 possible moves' do
          expect(knight.possible_moves(board).size).to eq(8)
        end
        it 'returns the correct movement array' do
          expect(knight.possible_moves(board)).to contain_exactly(
            [2, 3], [2, 5], [3, 2], [3, 6], [5, 2], [5, 6], [6, 3], [6, 5]
          )
        end
      end

      context 'when there are friendly pieces in the board' do
        context 'when knight is surrounded by friendly pieces' do
          before do
            board.add_piece(same_color_piece, [3, 3])
            board.add_piece(same_color_piece, [3, 4])
            board.add_piece(same_color_piece, [3, 5])
            board.add_piece(same_color_piece, [4, 3])
            board.add_piece(same_color_piece, [4, 5])
            board.add_piece(same_color_piece, [5, 3])
            board.add_piece(same_color_piece, [5, 4])
            board.add_piece(same_color_piece, [5, 5])
          end

          it 'returns 8 possible moves' do
            expect(knight.possible_moves(board).size).to eq(8)
          end

          it 'returns the correct movement array' do
            expect(knight.possible_moves(board)).to contain_exactly(
              [2, 3], [2, 5], [3, 2], [3, 6], [5, 2], [5, 6], [6, 3], [6, 5]
            )
          end
        end

        context 'when 2 friendly pieces are in a L-shaped position from knight' do
          before do
            board.add_piece(same_color_piece, [2, 3])
            board.add_piece(same_color_piece, [6, 5])
          end

          it 'returns 6 possible moves' do
            expect(knight.possible_moves(board).size).to eq(6)
          end

          it 'returns the correct movement array' do
            expect(knight.possible_moves(board)).to contain_exactly(
              [2, 5], [3, 2], [3, 6], [5, 2], [5, 6], [6, 3]
            )
          end
        end
      end

      context 'when there are opposing pieces in the board' do
        context 'when knight is surrounded by opposing pieces' do
          before do
            board.add_piece(opposing_color_piece, [3, 3])
            board.add_piece(opposing_color_piece, [3, 4])
            board.add_piece(opposing_color_piece, [3, 5])
            board.add_piece(opposing_color_piece, [4, 3])
            board.add_piece(opposing_color_piece, [4, 5])
            board.add_piece(opposing_color_piece, [5, 3])
            board.add_piece(opposing_color_piece, [5, 4])
            board.add_piece(opposing_color_piece, [5, 5])
          end

          it 'returns 8 possible moves' do
            expect(knight.possible_moves(board).size).to eq(8)
          end

          it 'returns the correct movement array' do
            expect(knight.possible_moves(board)).to contain_exactly(
              [2, 3], [2, 5], [3, 2], [3, 6], [5, 2], [5, 6], [6, 3], [6, 5]
            )
          end
        end

        context 'when 2 opposing pieces are in a L-shaped position from knight' do
          before do
            board.add_piece(opposing_color_piece, [2, 3])
            board.add_piece(opposing_color_piece, [6, 5])
          end

          it 'return 8 possible moves' do
            expect(knight.possible_moves(board).size).to eq(8)
          end

          it 'retirns the correct movement array' do
            expect(knight.possible_moves(board)).to contain_exactly(
              [2, 3], [2, 5], [3, 2], [3, 6], [5, 2], [5, 6], [6, 3], [6, 5]
            )
          end
        end
      end
    end
  end
end

RSpec.describe Knight do
  it_behaves_like 'a knight', :white, '♘'
  it_behaves_like 'a knight', :black, '♞'
end
