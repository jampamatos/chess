#frozen_string_literal: true

require_relative '../lib/pieces/king'
require_relative '../lib/pieces/rook'
require_relative '../lib/pieces/pawn'
require_relative '../lib/board'
require_relative '../lib/gamemanager'

RSpec.describe King do
  describe '#possible_moves' do
    let(:gm) { GameManager.new }
    let(:board) { Board.new }
    let(:white_king) { King.new('white') }
    let(:white_pawn) { Pawn.new('white') }
    let(:black_rook) { Rook.new('black') }
    let(:black_pawn1) { Pawn.new('black') }
    let(:black_pawn2) { Pawn.new('black') }

    context 'when the king is in the middle of the board' do
      before do
        board.set_piece(white_king, [4, 4])
      end

      it 'returns 8 possible moves' do
        expect(white_king.possible_moves(board).size).to eq 8
      end

      it 'returns all possible moves' do
        expect(white_king.possible_moves(board)).to contain_exactly(
          [3, 3], [3, 4], [3, 5], [4, 3],
          [4, 5], [5, 3], [5, 4], [5, 5]
        )
      end
    end

    context 'when the king is blocked by a friendly piece' do
      before do
        board.set_piece(white_king, [4, 4])
        board.set_piece(white_pawn, [3, 4])
      end

      it 'returns 7 possible moves' do
        expect(white_king.possible_moves(board).size).to eq 7
      end

      it 'returns all possible moves' do
        expect(white_king.possible_moves(board)).to contain_exactly(
          [3, 3], [3, 5], [4, 3], [4, 5], 
          [5, 3], [5, 4], [5, 5]
        )
      end
    end

    context 'when the king is blocked by an enemy piece' do
      before do
        board.set_piece(white_king, [4, 4])
        board.set_piece(black_pawn1, [3, 4])
      end

      it 'returns 8 possible moves' do
        white_king.possible_moves(board)
        expect(white_king.possible_moves(board).size).to eq 8
      end

      it 'returns all possible moves' do
        expect(white_king.possible_moves(board)).to contain_exactly(
          [3, 3], [3, 4], [3, 5], [4, 3],
          [4, 5], [5, 3], [5, 4], [5, 5]
        )
      end
    end

    context 'when king has two movement squares attacked by enemy pieces' do
      before do
        gm.board = board

        gm.board.active_pieces['white_king'] = white_king
        gm.board.set_piece(white_king, [4, 4])

        gm.board.active_pieces['black_pawn1'] = black_pawn1
        gm.board.set_piece(black_pawn1, [2, 2])

        gm.board.active_pieces['black_pawn2'] = black_pawn2
        gm.board.set_piece(black_pawn2, [2, 6])
      end

      it 'returns 6 possible moves' do
        expect(white_king.possible_moves(gm.board).size).to eq 6
      end

      it 'returns all possible moves' do
        expect(white_king.possible_moves(gm.board)).to contain_exactly(
          [3, 4], [4, 3], [4, 5], 
          [5, 3], [5, 4], [5, 5]
        )
      end
    end

    context 'when king is in check' do
      before do
        gm.board = board

        gm.board.active_pieces['white_king'] = white_king
        gm.board.set_piece(white_king, [4, 4])

        gm.board.active_pieces['black_pawn1'] = black_pawn1
        gm.board.set_piece(black_pawn1, [2, 2])

        gm.board.active_pieces['black_pawn2'] = black_pawn2
        gm.board.set_piece(black_pawn2, [2, 6])

        gm.board.active_pieces['black_rook'] = black_rook
        gm.board.set_piece(black_rook, [2, 5])
      end

      it 'returns only moves that will make king go out from check' do
        expect(white_king.possible_moves(gm.board).size).to eq 4
        expect(white_king.possible_moves(gm.board)).to contain_exactly(
          [3, 4], [4, 3], [5, 3], [5, 4]
        )
      end
    end
  end

  describe '#move' do
    let(:gm) { GameManager.new }
    let(:board) { Board.new }
    let(:white_king) { King.new('white') }
    let(:white_pawn) { Pawn.new('white') }
    let(:black_rook) { Rook.new('black') }
    let(:black_pawn1) { Pawn.new('black') }
    let(:black_pawn2) { Pawn.new('black') }

    context 'when destination is empty' do
      before do
        board.set_piece(white_king, [4, 4])
      end

      it 'moves the king to destination' do
        white_king.move([3, 4], board)
        expect(board[[3, 4]]).to eq(white_king)
        expect(board[[4, 4]]).to be_nil
      end

      it 'returns the correct move notation' do
        expect(white_king.move([3, 4], board).uncolorize).to eq('♔e5')
      end
    end

    context 'when destination is occupied by enemy piece' do
      before do
        board.set_piece(white_king, [4, 4])
        board.set_piece(black_pawn1, [3, 4])
      end

      it 'moves the king to destination and captures enemy piece' do
        white_king.move([3, 4], board)
        expect(board[[3, 4]]).to eq(white_king)
        expect(board[[4, 4]]).to be_nil
      end

      it 'returns the correct move notation' do
        expect(white_king.move([3, 4], board).uncolorize).to eq('♔e4x♟e5')
      end
    end

    context 'when destination is occupied by frendly piece' do
      it 'raises an InvalidMoveError and does not move the king' do
        board.set_piece(white_king, [4, 4])
        board.set_piece(white_pawn, [3, 4])
        expect { white_king.move([6, 0], board, gm) }.to raise_error(InvalidMoveError)
        expect(board[[4, 4]]).to eq(white_king)
        expect(board[[3, 4]]).to eq(white_pawn)
      end
    end

    context 'when destination puts king in check' do
      before do
        gm.board = board

        gm.board.active_pieces['white_king'] = white_king
        gm.board.set_piece(white_king, [4, 4])

        gm.board.active_pieces['black_pawn1'] = black_pawn1
        gm.board.set_piece(black_pawn1, [2, 2])

        gm.board.active_pieces['black_pawn2'] = black_pawn2
        gm.board.set_piece(black_pawn2, [2, 6])

        gm.board.active_pieces['black_rook'] = black_rook
        gm.board.set_piece(black_rook, [2, 5])
      end

      it 'raises an InvalidMoveError and does not move the king' do
        expect { white_king.move([4, 5], board, gm) }.to raise_error(InvalidMoveError)
        expect(board[[4, 4]]).to eq(white_king)
      end
    end
  end
end
