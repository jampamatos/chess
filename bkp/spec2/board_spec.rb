# frozen_string_literal: true

require_relative '../lib/dependencies'

RSpec.describe Board do
  let(:board) { Board.new }
  let(:piece1) { Piece.new(:white, :piece, 'P') }
  let(:piece2) { Piece.new(:black, :piece, 'P') }
  let(:piece3) { Piece.new(:white, :piece, 'P') }
  let(:piece4) { Piece.new(:black, :piece, 'P') }
  let(:piece5) { Piece.new(:white, :piece, 'P') }

  describe '#initialize' do
    it 'initializes an empty grid' do
      expect(board.grid.flatten.all?(&:nil?)).to be(true)
    end

    it 'initializes an empty active_pieces hash' do
      expect(board.active_pieces).to be_empty
    end
  end

  describe '#add_piece' do
    context 'when we try to add a piece to an empty square' do
      let(:position) { [0, 0] }

      before do
        board.add_piece(piece1, position)
      end

      it 'adds the piece to the square' do
        expect(board.piece_at(position)).to eq(piece1)
      end

      it 'updates piece.position correctly' do
        expect(piece1.position).to eq(position)
      end

      it 'updates active_pieces correctly' do
        expect(board.active_pieces.values).to include(piece1)
      end
    end

    context 'when we try to add a piece to an occupied square' do
      let(:position) { [0, 0] }

      before do
        board.add_piece(piece1, position)
      end

      it 'raises a PositionNotEmptyError' do
        expect { board.add_piece(piece2, position) }.to raise_error(PositionNotEmptyError)
      end

      it 'does not add the piece to the board' do
        begin
          board.add_piece(piece2, position)
        rescue PositionNotEmptyError
          # Ignoring the error for this test case
        end

        expect(board.piece_at(position)).to eq(piece1)
        expect(board.grid.flatten).not_to include(piece2)
      end

      it 'does not add the piece to active_pieces' do
        begin
          board.add_piece(piece2, position)
        rescue PositionNotEmptyError
          # Ignoring the error for this test case
        end

        expect(board.active_pieces.values).not_to include(piece2)
      end
    end

    context 'when we try to add a piece to an invalid position' do
      let(:position) { [9, 9] }

      it 'raises an InvalidPositionError' do
        expect { board.add_piece(piece1, position) }.to raise_error(InvalidPositionError)
      end

      it 'does not add the piece to the board' do
        begin
          board.add_piece(piece1, position)
        rescue InvalidPositionError
          # Ignoring the error for this test case
        end
        expect(board.grid.flatten).not_to include(piece1)
      end

      it 'does not add the piece to active_pieces' do
        begin
          board.add_piece(piece1, position)
        rescue InvalidPositionError
          # Ignoring the error for this test case
        end

        expect(board.active_pieces.values).not_to include(piece1)
      end
    end
  end

  describe '#remove_piece' do
    context 'when we try to remove a piece that is on the board' do
      let(:position) { [0, 0] }

      before do
        board.add_piece(piece1, position)
      end

      it 'removes the piece from the board' do
        board.remove_piece(position)
        expect(board.piece_at(position)).to be_nil
      end

      it 'removes the piece from active_pieces' do
        expect(board.active_pieces.values).to include(piece1)
        board.remove_piece(position)
        expect(board.active_pieces.values).not_to include(piece1)
      end
    end

    context 'when we try to remove a piece in an invalid position' do
      let(:position) { [9, 9] }

      it 'raises an InvalidPositionError' do
        expect { board.remove_piece(position) }.to raise_error(InvalidPositionError)
      end
    end
  end

  describe '#move_piece' do
    context 'when we try to move a piece to a valid position' do
      let(:initial_position) { [0, 0] }
      let(:new_position) { [1, 1] }

      before do
        board.add_piece(piece1, initial_position)
        allow(piece1).to receive(:possible_moves).and_return([new_position])
        board.move_piece(piece1, new_position)
      end

      it 'removes the piece from the old position' do
        expect(board.piece_at(initial_position)).to be_nil
      end

      it 'puts the piece correctly in the new position' do
        expect(board.piece_at(new_position)).to eq(piece1)
      end

      it 'updates piece.position correctly' do
        expect(piece1.position).to eq(new_position)
      end

      it 'does not change the active_pieces hash' do
        expect(board.active_pieces.values).to include(piece1)
      end

      it 'does not change the number of active pieces' do
        expect(board.active_pieces.size).to eq(1)
      end

      it 'does not change the number of pieces in the grid' do
        expect(board.grid.flatten.compact.size).to eq(1)
      end

      it 'marks the piece as moved' do
        expect(piece1.moved).to be(true)
      end
    end

    context 'when we try to move a piece to a position occupied by a friendly piece' do
      let(:initial_position) { [0, 0] }
      let(:new_position) { [1, 1] }

      before do
        board.add_piece(piece1, initial_position)
        allow(piece1).to receive(:possible_moves).and_return([new_position])
        board.add_piece(piece3, new_position)
      end

      it 'raises a PositionNotEmpty error' do
        expect { board.move_piece(piece1, new_position) }.to raise_error(PositionNotEmptyError)
      end

      it 'does not move the piece' do
        begin
          board.move_piece(piece1, new_position)
        rescue PositionNotEmptyError
          # Ignoring the error for this test case
        end

        expect(board.piece_at(initial_position)).to eq(piece1)
        expect(board.piece_at(new_position)).to eq(piece3)
      end
    end

    context 'when we try to move a piece to a position occupied by an opponent piece' do
      let(:initial_position) { [0, 0] }
      let(:new_position) { [1, 1] }

      before do
        board.add_piece(piece1, initial_position)
        board.add_piece(piece2, new_position)
        allow(piece1).to receive(:possible_moves).and_return([new_position])
        board.move_piece(piece1, new_position)
      end
      it 'removes the opponent piece from the board' do
        expect(board.grid).not_to include(piece2)
      end

      it 'removes the opponent piece from active_pieces' do
        expect(board.active_pieces).not_to include(piece2)
      end

      it 'moves the piece to the new position' do
        expect(board.piece_at(new_position)).to eq(piece1)
      end
    end

    context 'when we try to move a piece to an invaid position' do
      let(:initial_position) { [0, 0] }
      let(:new_position) { [9, 9] }

      before do
        board.add_piece(piece1, initial_position)
      end
      it 'raises an InvalidPositionError' do
        expect { board.move_piece(piece1, new_position) }.to raise_error(InvalidPositionError)
      end

      it 'does not move the piece' do
        begin
          board.move_piece(piece1, new_position)
        rescue InvalidPositionError
          # Ignoring the error for this test case
        end

        expect(board.piece_at(initial_position)).to eq(piece1)
        expect(board.piece_at(new_position)).to be_nil
      end
    end

    context "when we pass 'nil' as a piece argument" do
      it 'raises a NoPieceError' do
        expect { board.move_piece(nil, [0, 0]) }.to raise_error(NoPieceError)
      end
    end

    context 'when we try to move a piece to a position that is not in its possible moves' do
      let(:initial_position) { [0, 0] }
      let(:new_position) { [1, 1] }

      before do
        board.add_piece(piece1, initial_position)
        allow(piece1).to receive(:possible_moves).and_return([])
      end

      it 'raises a InvalidMoveError' do
        expect { board.move_piece(piece1, new_position) }.to raise_error(InvalidMoveError)
      end

      it 'does not move the piece' do
        begin
          board.move_piece(piece1, new_position)
        rescue InvalidMoveError
          # Ignoring the error for this test case
        end

        expect(board.piece_at(initial_position)).to eq(piece1)
        expect(board.piece_at(new_position)).to be_nil
      end
    end
  end

  describe '#piece_at' do
    before do
      board.add_piece(piece1, [0, 0])
      board.add_piece(piece2, [1, 1])
    end

    context 'when we pass a position that holds a piece' do
      it 'returns the piece' do
        expect(board.piece_at([0, 0])).to eq(piece1)
        expect(board.piece_at([1, 1])).to eq(piece2)
      end
    end

    context 'when we pass an empty position' do
      it 'returns nil' do
        expect(board.piece_at([0, 1])).to be_nil
        expect(board.piece_at([1, 0])).to be_nil
      end
    end
  end

  describe '#position_of' do
    before do
      board.add_piece(piece1, [0, 0])
      board.add_piece(piece2, [1, 1])
    end

    context 'when we pass a piece object' do
      it 'returns the position of the piece' do
        expect(board.position_of(piece1)).to eq([0, 0])
        expect(board.position_of(piece2)).to eq([1, 1])
      end
    end

    context 'when we pass an object which is not an instance of Piece' do
      it 'raises a NoPieceError' do
        expect { board.position_of(nil) }.to raise_error(NoPieceError)
      end
    end
  end

  describe '#pieces_of_color' do
    before do
      board.add_piece(piece1, [0, 0])
      board.add_piece(piece2, [1, 1])
      board.add_piece(piece3, [2, 2])
      board.add_piece(piece4, [3, 3])
      board.add_piece(piece5, [4, 4])
    end
    context 'when there are 3 white pieces and 2 black pieces in active_pieces' do
      it "expect pieces_of_color(:white) to return an array of size 3" do
        white_pieces = board.pieces_of_color(:white)
        expect(white_pieces).to be_an(Array)
        expect(white_pieces.size).to eq(3)
      end

      it "expect pieces_of_color(:white) to return the three correct white pieces" do
        white_pieces = board.pieces_of_color(:white)
        expect(white_pieces).to include(piece1)
        expect(white_pieces).to include(piece3)
        expect(white_pieces).to include(piece5)
      end

      it "expect pieces_of_color(:black) to return an array of size 2" do
        black_pieces = board.pieces_of_color(:black)
        expect(black_pieces).to be_an(Array)
        expect(black_pieces.size).to eq(2)
      end

      it "expect pieces_of_color(:black) to return the three correct white pieces" do
        black_pieces = board.pieces_of_color(:black)
        expect(black_pieces).to include(piece2)
        expect(black_pieces).to include(piece4)
      end
    end
  end

  describe '#friendly_pieces_of_type' do
    before do
      board.add_piece(piece1, [0, 0])
      board.add_piece(piece2, [1, 1])
      board.add_piece(piece3, [2, 2])
      board.add_piece(piece4, [3, 3])
      board.add_piece(piece5, [4, 4])
    end

    context 'when there are 3 white pieces and 2 black pieces in active_pieces' do
      it "expect friendly_pieces_of_type(:piece, :white) to return an array of size 3" do
        white_pieces = board.friendly_pieces_of_type(:piece, :white)
        expect(white_pieces).to be_an(Array)
        expect(white_pieces.size).to eq(3)
      end

      it "expect friendly_pieces_of_type(:piece, :white) to return the three correct white pieces" do
        white_pieces = board.friendly_pieces_of_type(:piece, :white)
        expect(white_pieces).to include(piece1)
        expect(white_pieces).to include(piece3)
        expect(white_pieces).to include(piece5)
      end

      it "expect friendly_pieces_of_type(:piece, :black) to return an array of size 2" do
        black_pieces = board.friendly_pieces_of_type(:piece, :black)
        expect(black_pieces).to be_an(Array)
        expect(black_pieces.size).to eq(2)
      end

      it "expect friendly_pieces_of_type(:piece, :black) to return the three correct black pieces" do
        black_pieces = board.friendly_pieces_of_type(:piece, :black)
        expect(black_pieces).to include(piece2)
        expect(black_pieces).to include(piece4)
      end
    end
  end

  describe '#set_up_board' do
    context 'when we call set_up_board' do
      before do
        board.set_up_board
      end

      it 'adds 32 pieces to the board' do
        expect(board.active_pieces.size).to eq(32)
      end

      it 'adds 16 white pieces to the board' do
        white_pieces = board.pieces_of_color(:white)
        expect(white_pieces.size).to eq(16)
      end

      it 'adds 16 black pieces to the board' do
        black_pieces = board.pieces_of_color(:black)
        expect(black_pieces.size).to eq(16)
      end

      it 'adds 8 white pawns to the board' do
        pawns = board.friendly_pieces_of_type(:pawn, :white)
        expect(pawns.size).to eq(8)
      end

      it 'adds 8 black pawns to the board' do
        pawns = board.friendly_pieces_of_type(:pawn, :black)
        expect(pawns.size).to eq(8)
      end

      it 'adds 2 white rooks to the board' do
        rooks = board.friendly_pieces_of_type(:rook, :white)
        expect(rooks.size).to eq(2)
      end

      it 'adds 2 black rooks to the board' do
        rooks = board.friendly_pieces_of_type(:rook, :black)
        expect(rooks.size).to eq(2)
      end

      it 'adds 2 white knights to the board' do
        knights = board.friendly_pieces_of_type(:knight, :white)
        expect(knights.size).to eq(2)
      end

      it 'adds 2 black knights to the board' do
        knights = board.friendly_pieces_of_type(:knight, :black)
        expect(knights.size).to eq(2)
      end

      it 'adds 2 white bishops to the board' do
        bishops = board.friendly_pieces_of_type(:bishop, :white)
        expect(bishops.size).to eq(2)
      end

      it 'adds 2 black bishops to the board' do
        bishops = board.friendly_pieces_of_type(:bishop, :black)
        expect(bishops.size).to eq(2)
      end

      it 'adds 1 white queen to the board' do
        queens = board.friendly_pieces_of_type(:queen, :white)
        expect(queens.size).to eq(1)
      end

      it 'adds 1 black queen to the board' do
        queens = board.friendly_pieces_of_type(:queen, :black)
        expect(queens.size).to eq(1)
      end

      it 'adds 1 white king to the board' do
        kings = board.friendly_pieces_of_type(:king, :white)
        expect(kings.size).to eq(1)
      end

      it 'adds 1 black king to the board' do
        kings = board.friendly_pieces_of_type(:king, :black)
        expect(kings.size).to eq(1)
      end
    end
  end

  describe '#king_in_check?' do
    let(:white_king) { King.new(:white) }
    let(:black_queen) { Queen.new(:black) }

    context 'when there is no piece attacking the king' do
      before do
        board.add_piece(white_king, [0, 0])
        board.add_piece(black_queen, [6, 5])
      end

      it 'returns false' do
        expect(board.king_in_check?(:white)).to be(false)
      end
    end

    context 'when there is a piece attacking the king' do
      before do
        board.add_piece(white_king, [0, 0])
        board.add_piece(black_queen, [0, 5])
      end

      it 'returns true' do
        expect(board.king_in_check?(:white)).to be(true)
      end
    end
  end
end
