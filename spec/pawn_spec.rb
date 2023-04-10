# frozen_string_literal: true

require_relative '../lib/dependencies'

RSpec.shared_examples 'a pawn' do |color, symbol, &block|
  let(:board) { Board.new }
  let(:pawn) { Pawn.new(color) }
  let(:opposing_pawn) { Pawn.new(color == :white ? :black : :white) }
  let(:same_color_piece) { Piece.new(color, :piece, 'P') }
  let(:opposing_color_piece) { Piece.new(color == :white ? :black : :white, :piece, 'P') }
  let(:friendly_king) { King.new(color) }
  let(:opposing_king) { King.new(color == :white ? :black : :white) }

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

  describe '#possible_moves' do
    instance_exec(&block) if block_given?

    context 'when pawn set to the middle of the board' do
      before do
        board.place_piece(pawn, [4, 4])
      end

      context 'and there are no other pieces in the board' do
        context 'and the pawn has not moved yet' do
          it 'returns 2 possible moves' do
            expect(pawn.possible_moves(board).size).to eq(2)
          end

          it 'returns the correct movement array' do
            expect(pawn.possible_moves(board)).to contain_exactly(*two_moves)
          end
        end

        context 'and the pawn has moved' do
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

      context 'and there is a piece of the same color in front of the pawn' do
        before do
          board.place_piece(same_color_piece, *one_move)
        end

        it 'returns 0 possible moves' do
          expect(pawn.possible_moves(board).size).to eq(0)
        end
      end

      context 'and there is a piece of the opposing color in front of the pawn' do
        before do
          board.place_piece(opposing_color_piece, *one_move)
        end

        it 'returns 0 possible moves' do
          expect(pawn.possible_moves(board).size).to eq(0)
        end
      end

      context 'and there is a piece of the opposing color diagonally in front of the pawn' do
        before do
          board.place_piece(opposing_color_piece, *diagonal_move)
        end

        it 'returns 2 possible move' do
          expect(pawn.possible_moves(board).size).to eq(2)
        end

        it 'returns the correct movement array' do
          expect(pawn.possible_moves(board)).to contain_exactly(*capture_moves)
        end
      end
    end
  end

  describe 'GameManager#move_piece' do
    before do
      board.place_piece(pawn, *move_start_square)
      pawn.mark_as_moved
      board.place_piece(opposing_pawn, [4, 4])
      board.place_piece(friendly_king, [7, 7])
      board.place_piece(opposing_king, [0, 0])
    end

    let(:gm) { GameManager.new(board) }

    context 'when pawn can move normally' do
      context 'and it moves one square forward' do
        it 'moves the pawn to the correct square' do
          gm.move_piece(*move_start_square, *move_end_square)
          expect(board.piece_at(*move_end_square)).to eq(pawn)
        end

        it 'removes the pawn from the starting square' do
          gm.move_piece(*move_start_square, *move_end_square)
          expect(board.piece_at(*move_start_square)).to be_nil
        end

        it 'returns correct move notation when called #to_s' do
          expect(gm.move_piece(*move_start_square, *move_end_square).to_s).to eq(move_notation)
        end
      end

      context 'and it moves two squares forward' do
        before do
          pawn.mark_as_not_moved
        end
        it 'moves the pawn to the correct square' do
          gm.move_piece(*move_start_square, *move_end_square_two)
          expect(board.piece_at(*move_end_square_two)).to eq(pawn)
        end

        it 'removes the pawn from the starting square' do
          gm.move_piece(*move_start_square, *move_end_square_two)
          expect(board.piece_at(*move_start_square)).to be_nil
        end

        it 'returns correct move notation when called #to_s' do
          expect(gm.move_piece(*move_start_square, *move_end_square_two).to_s).to eq(move_notation_two)
        end
      end
    end

    context 'when pawn can capture en passant' do
      before do
        gm.move_piece([4, 4], *passant_end_square)
      end

      it 'returns 2 possible moves' do
        expect(pawn.possible_moves(board).size).to eq(2)
      end

      it 'returns the correct movement array' do
        expect(pawn.possible_moves(board)).to contain_exactly(*passant_possible_moves)
      end

      it 'removes the opposing pawn' do
        gm.move_piece(*move_start_square, *passant_capture_move)
        expect(board.piece_at(*passant_end_square)).to be_nil
      end

      it 'returns correct move notation when called #to_s' do
        expect(gm.move_piece(*move_start_square, *passant_capture_move).to_s).to eq(passant_move_notation)
      end
    end
  end

  describe 'Pawn promotion' do
    before do
      board.place_piece(pawn, *promotion_start_square)
      board.place_piece(friendly_king, [7, 7])
      board.place_piece(opposing_king, [0, 0])
    end

    let(:gm) { GameManager.new(board) }


    context 'when a pawn reaches the other side of the board' do
      it 'promotes the pawn to a queen when user type "q"' do
        allow(gm).to receive(:gets).and_return("q\n")
        gm.move_piece(*promotion_start_square, *promotion_move)
        expect(board.piece_at(*promotion_move)).to be_a(Queen)
        expect(board.piece_at(*promotion_move).color).to eq(pawn.color)
        expect(gm.board.active_pieces.values).to include(board.piece_at(*promotion_move))
        expect(gm.board.active_pieces.values).not_to include(pawn)
      end

      it 'promotes the pawn to a queen when user type "queen"' do
        allow(gm).to receive(:gets).and_return("queen\n")
        gm.move_piece(*promotion_start_square, *promotion_move)
        expect(board.piece_at(*promotion_move)).to be_a(Queen)
        expect(board.piece_at(*promotion_move).color).to eq(pawn.color)
        expect(gm.board.active_pieces.values).to include(board.piece_at(*promotion_move))
        expect(gm.board.active_pieces.values).not_to include(pawn)
      end

      it 'returns correct move notation when called #to_s' do
        allow(gm).to receive(:gets).and_return("queen\n")
        expect(gm.move_piece(*promotion_start_square, *promotion_move).to_s).to eq(promotion_move_notation)
      end
    end
  end
end

RSpec.describe Pawn do
  describe 'white pawn' do
    it_behaves_like 'a pawn', :white, '♟︎'.colorize(:white) do
      let(:two_moves) { [[3, 4], [2, 4]] }
      let(:one_move) { [[3, 4]] }
      let(:diagonal_move) { [[2, 3]] }
      let(:capture_moves) { [[2, 4], [3, 4]] }
      let(:move_start_square) { [[6, 5]] }
      let(:move_end_square) { [[5, 5]] }
      let(:move_end_square_two) { [[4, 5]] }
      let(:move_notation) { 'f3'}
      let(:move_notation_two) { 'f4' }
      let(:passant_end_square) { [[6, 4]] }
      let(:passant_possible_moves) { [[5, 5], [5, 4]] }
      let(:passant_capture_move) { [[5, 4]] }
      let(:passant_move_notation) { 'fxe3 e.p.'}
      let(:promotion_start_square) { [[1, 4]] }
      let(:promotion_move) { [[0, 4]] }
      let(:promotion_move_notation) { 'e8=Q' }
    end
  end

  describe 'black pawn' do
    it_behaves_like 'a pawn', :black, '♟︎'.colorize(:black) do
      let(:two_moves) { [[5, 4], [6, 4]] }
      let(:one_move) { [[5, 4]] }
      let(:diagonal_move) { [[6, 3]] }
      let(:capture_moves) { [[6, 4], [5, 4]] }
      let(:move_start_square) { [[2, 5]] }
      let(:move_end_square) { [[3, 5]] }
      let(:move_end_square_two) { [[4, 5]] }
      let(:move_notation) { 'f5'}
      let(:move_notation_two) { 'f4' }
      let(:passant_end_square) { [[2, 4]] }
      let(:passant_possible_moves) { [[3, 5], [3, 4]] }
      let(:passant_capture_move) { [[3, 4]] }
      let(:passant_move_notation) { 'fxe5 e.p.'}
      let(:promotion_start_square) { [[6, 4]] }
      let(:promotion_move) { [[7, 4]] }
      let(:promotion_move_notation) { 'e1=Q' }
    end
  end
end
