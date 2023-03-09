# frozen_string_literal: true

require_relative '../lib/pawn'
require_relative '../lib/board'

describe Pawn do
  describe "#possible_moves" do
    let(:board) { Board.new }
    let(:white_pawn) { Pawn.new('white') }
    let(:moved_white_pawn) { Pawn.new('white', true) }

    context "when pawn has not moved" do
      it "returns two possible movements" do
        moves = white_pawn.possible_moves(board, [6, 0])
        expect(moves.size).to eq(2)
        expect(moves).to include([5, 0], [4, 0])
      end
    end

    context "when pawn has already moved" do
      it "returns one possible movement" do
        moves = moved_white_pawn.possible_moves(board, [4, 4])
        expect(moves.size).to eq(1)
        expect(moves).to include([3, 4])
      end
    end

    context "when pawn is blocked" do
      it "returns zero possible movements" do
        board.set_piece(Pawn.new(:black), [3, 4])
        moves = white_pawn.possible_moves(board, [4, 4])
        expect(moves.size).to eq(0)
      end
    end

    context "when pawn is not blocked and have an enemy piece to both diagonals" do
      it "returns three possible movements" do
        board.set_piece(Pawn.new(:black), [3, 3])
        board.set_piece(Pawn.new(:black), [3, 5])
        moves = moved_white_pawn.possible_moves(board, [4, 4])
        expect(moves.size).to eq(3)
        expect(moves).to include([3, 3], [3, 5], [3, 4])
      end
    end

    context "when enemy pawn can be captured en passant" do
      it "returns all possible movements" do
        board.en_passant = [3, 3]
        moves = moved_white_pawn.possible_moves(board, [4, 4])
        expect(moves.size).to eq(2)
        expect(moves).to include([3, 3], [3, 4])
      end
    end
  end
end
