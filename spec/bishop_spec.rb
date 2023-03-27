# frozen_string_literal: true

require_relative '../lib/dependencies'

RSpec.shared_examples 'a bishop' do |color, symbol|
  let(:board) { Board.new }

  let(:bishop) { described_class.new(color) }

  let(:friendly_color_piece) { Piece.new(color, :piece, 'P') }

  let(:opposing_color_piece) { Piece.new(color == :white ? :black : :white, :piece, 'P') }

  describe '#initialize' do
    context "when creating a #{color} bishop" do
      it "creates a piece of the #{color} color" do
        expect(bishop.color).to eq(color)
      end

      it 'creates a piece of the bishop type' do
        expect(bishop.type).to eq(:bishop)
      end

      it 'prints the correct symbol' do
        expect(bishop.to_s).to eq(symbol)
      end
    end
  end

  describe '#same_color_as' do
    context "when bishop is #{color}" do
      it 'returns true if a piece is of same color' do
        expect(bishop.same_color_as(friendly_color_piece)).to be_truthy
      end

      it 'returns false if a piece is of different color' do
        expect(bishop.same_color_as(opposing_color_piece)).to be_falsy
      end
    end
  end

  describe '#possible_moves' do
    context "when bishop is #{color} and set to the middle of the board" do
      before do
        board.add_piece(bishop, [4, 4])
      end

      context 'when there are no other pieces in the board' do
        it 'returns 13 possible moves' do
          expect(bishop.possible_moves(board).size).to eq(13)
        end

        it 'returns the correct movement array' do
          expect(bishop.possible_moves(board)).to contain_exactly(
            [5, 5], [6, 6], [7, 7], [3, 3], [2, 2], [1, 1], [0, 0],
            [3, 5], [2, 6], [1, 7], [5, 3], [6, 2], [7, 1]
          )
        end
      end

      context 'when there are friendly pieces in the path' do
        context 'when the pieces are along the diagonal' do
          before do
            board.add_piece(friendly_color_piece, [2, 2])

            board.add_piece(friendly_color_piece, [2, 6])
          end

          it 'returns 8 possible moves' do
            expect(bishop.possible_moves(board).size).to eq(8)
          end

          it 'returns the correct movement array' do
            expect(bishop.possible_moves(board)).to contain_exactly(
              [3, 3], [3, 5], [5, 3], [5, 5],
              [6, 2], [6, 6], [7, 1], [7, 7]
            )
          end
        end
      end

      context 'when there are opposing pieces in the path' do
        context 'when the pieces are along the diagonal' do
          before do
            board.add_piece(opposing_color_piece, [2, 2])

            board.add_piece(opposing_color_piece, [2, 6])
          end

          it 'returns 10 possible moves' do
            expect(bishop.possible_moves(board).size).to eq(10)
          end

          it 'returns the correct movement array' do
            expect(bishop.possible_moves(board)).to contain_exactly(
              [2, 2], [2, 6], [3, 3], [3, 5], [5, 3],
              [5, 5], [6, 2], [6, 6], [7, 1], [7, 7]
            )
          end
        end
      end
    end
  end
end

RSpec.describe Bishop do
  describe 'white bishop' do
    include_examples 'a bishop', :white, '♗'
  end

  describe 'black bishop' do
    include_examples 'a bishop', :black, '♝'
  end
end
