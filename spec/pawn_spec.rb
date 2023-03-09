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

  describe "#move" do
    let(:board) { Board.new }
    let(:game_manager) { instance_double('GameManager') }
    let(:white_pawn) { Pawn.new('white') }
    let(:white_pawn2) { Pawn.new('white') }
    let(:black_pawn) { Pawn.new('black') }

    context 'when destination is a valid move' do
      context 'when destination is one step ahead' do
        it 'moves the pawn to destination' do
          board.set_piece(white_pawn, [6, 0])
          white_pawn.move([5, 0], board)
          expect(board[[5, 0]]).to eq(white_pawn)
          expect(board[[6, 0]]).to be_nil
        end

        it 'returns the correct move notation' do
          board.set_piece(white_pawn, [6, 0])
          notation = white_pawn.move([5, 0], board).uncolorize
          expect(notation).to eq('♟a3')
        end
      end

      context 'when destination is two steps ahead' do
        it 'moves the pawn to destination' do
          board.set_piece(white_pawn, [6, 0])
          white_pawn.move([4, 0], board)
          expect(board[[4, 0]]).to eq(white_pawn)
          expect(board[[6, 0]]).to be_nil
        end

        it 'sets en passant to A3' do
          board.set_piece(white_pawn, [6, 0])
          white_pawn.move([4, 0], board)
          expect(board.en_passant).to eq([5, 0])
        end

        it 'returns the correct move notation' do
          board.set_piece(white_pawn, [6, 0])
          notation = white_pawn.move([4, 0], board).uncolorize
          expect(notation).to eq('♟a4')
        end
      end

      context 'when destination is diagonal and occupied by an enemy piece' do
        it 'moves the pawn to destination' do
          black_pawn = Pawn.new('black')
          board.set_piece(white_pawn, [6, 0])
          board.set_piece(black_pawn, [5, 1])
          white_pawn.move([5, 1], board)
          expect(board[[5, 1]]).to eq(white_pawn)
          expect(board[[6, 0]]).to be_nil
        end

        it 'returns the correct move notation' do
          black_pawn = Pawn.new('black')
          board.set_piece(white_pawn, [6, 0])
          board.set_piece(black_pawn, [5, 1])
          notation = white_pawn.move([5, 1], board).uncolorize
          expect(notation).to eq('♟a2x♟b3')
        end
      end

      xcontext 'when en passant capture is possible' do
        it 'captures the opposing pawn and moves to the destination' do
          board.set_piece(white_pawn, [3, 4])
          board.set_piece(black_pawn, [1, 3])
          black_pawn.move([3, 3], board)
          white_pawn.move([2, 3], board)
          expect(white_pawn.move([2, 3], board)).to eq("dxe6 e.p.")
          expect(board[[2, 3]]).to eq(white_pawn)
          expect(board[[3, 3]]).to be_nil
          expect(board[[3, 4]]).to be_nil
        end
    
        xit "returns the correct move notation" do
          board.set_piece(white_pawn, [3, 4])
          board.set_piece(black_pawn, [1, 3])
          board.move_piece([1, 3], [3, 3])
          expect(white_pawn.move([2, 3], board)).to eq("dxe6 e.p.")
        end
      end
    end

    context 'when destination is an invalid move' do
      context 'when destination is occupied by a piece of the same color' do
        it 'raises an InvalidMoveError and does not move the pawn' do
          board.set_piece(white_pawn, [6, 0])
          board.set_piece(white_pawn2, [5, 0])
          expect { white_pawn.move([6, 0], board) }.to raise_error(InvalidMoveError)
          expect(board[[6, 0]]).to eq(white_pawn)
          expect(board[[5, 0]]).to eq(white_pawn2)
        end
      end

      context 'when destination is in front of the pawn and the square is occupied by a piece of different color' do
        it 'raises an InvalidMoveError and does not move the pawn' do
          board.set_piece(white_pawn, [6, 0])
          board.set_piece(black_pawn, [5, 0])
          expect { white_pawn.move([6, 0], board) }.to raise_error(InvalidMoveError)
          expect(board[[6, 0]]).to eq(white_pawn)
          expect(board[[5, 0]]).to eq(black_pawn)
        end
      end
    end
  end
end
