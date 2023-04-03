# frozen_string_literal: true

require_relative '../lib/dependencies'

PIECES = [
  { type: :pawn, count: 8, starting_rows: [1, 6] },
  { type: :rook, count: 2, starting_positions: [[0, 0], [0, 7], [7, 0], [7, 7]] },
  { type: :knight, count: 2, starting_positions: [[0, 1], [0, 6], [7, 1], [7, 6]] },
  { type: :bishop, count: 2, starting_positions: [[0, 2], [0, 5], [7, 2], [7, 5]] },
  { type: :queen, count: 1, starting_positions: [[0, 3], [7, 3]] },
  { type: :king, count: 1, starting_positions: [[0, 4], [7, 4]] },
]

RSpec.describe Board do
  let(:board) { Board.new }

  describe '#initialize' do
    it 'creates a new Board object' do
      expect(board).to be_a(Board)
    end

    it 'creates a 8x8 grid' do
      expect(board.grid.length).to eq(8)
      expect(board.grid[0].length).to eq(8)
    end

    it 'creates a grid with 64 squares' do
      expect(board.grid.flatten.length).to eq(64)
    end

    it 'creates an empty grid' do
      expect(board.grid.flatten.all?(&:nil?)).to be(true)
    end

    it 'creates an empty @active_pieces hash' do
      expect(board.active_pieces).to be_a(Hash)
      expect(board.active_pieces.empty?).to be(true)
    end

    it 'creates an empty @en_passant_target' do
      expect(board.en_passant_target).to be_nil
    end
  end

  describe '#place_piece' do
    let(:white_pawn1) { Pawn.new(:white) }

    context 'when placing one piece' do
      it 'places a piece on the board' do
        board.place_piece(white_pawn1, [1, 1])
        expect(board.grid[1][1]).to be(white_pawn1)
      end

      it 'adds the piece to the @active_pieces hash' do
        board.place_piece(white_pawn1, [1, 1])
        expect(board.active_pieces.values.include?(white_pawn1)).to be(true)
      end

      it 'raises an error if the square is occupied' do
        board.place_piece(white_pawn1, [1, 1])
        expect { board.place_piece(white_pawn1, [1, 1]) }.to raise_error(PositionNotEmptyError)
      end

      it 'raises an error if the position is invalid' do
        expect { board.place_piece(white_pawn1, [9, 9]) }.to raise_error(InvalidPositionError)
      end
    end

    context 'when placing multiple pieces' do
      let(:white_pawn2) { Pawn.new(:white) }
      let(:white_pawn3) { Pawn.new(:white) }
      let(:black_pawn1) { Pawn.new(:black) }
      let(:black_pawn2) { Pawn.new(:black) }
      let(:black_pawn3) { Pawn.new(:black) }

      before do
        board.place_piece(white_pawn1, [1, 1])
        board.place_piece(white_pawn2, [2, 2])
        board.place_piece(white_pawn3, [3, 3])
        board.place_piece(black_pawn1, [4, 4])
        board.place_piece(black_pawn2, [5, 5])
        board.place_piece(black_pawn3, [6, 6])
      end

      it 'places multiple pieces on the board' do
        expect(board.grid[1][1]).to be(white_pawn1)
        expect(board.grid[2][2]).to be(white_pawn2)
        expect(board.grid[3][3]).to be(white_pawn3)
        expect(board.grid[4][4]).to be(black_pawn1)
        expect(board.grid[5][5]).to be(black_pawn2)
        expect(board.grid[6][6]).to be(black_pawn3)
      end

      it 'adds the pieces to the @active_pieces hash' do
        expect(board.active_pieces.values.size).to eq(6)
        expect(board.active_pieces.values.include?(white_pawn1)).to be(true)
        expect(board.active_pieces.values.include?(white_pawn2)).to be(true)
        expect(board.active_pieces.values.include?(white_pawn3)).to be(true)
        expect(board.active_pieces.values.include?(black_pawn1)).to be(true)
        expect(board.active_pieces.values.include?(black_pawn2)).to be(true)
        expect(board.active_pieces.values.include?(black_pawn3)).to be(true)
      end
    end
  end

  describe '#take_piece' do
    let(:white_pawn1) { Pawn.new(:white) }
    let(:white_pawn2) { Pawn.new(:white) }
    let(:black_pawn1) { Pawn.new(:black) }
    let(:black_pawn2) { Pawn.new(:black) }

    before do
      board.place_piece(white_pawn1, [1, 1])
      board.place_piece(white_pawn2, [2, 2])
      board.place_piece(black_pawn1, [3, 3])
      board.place_piece(black_pawn2, [4, 4])
    end

    it 'removes the piece from the board' do
      board.take_piece([1, 1])
      expect(board.grid[1][1]).to be_nil
    end

    it 'removes the piece from the @active_pieces hash' do
      board.take_piece([1, 1])
      expect(board.active_pieces.values.include?(white_pawn1)).to be(false)
    end

    it 'raises an error if the position is invalid' do
      expect { board.take_piece([9, 9]) }.to raise_error(InvalidPositionError)
    end
  end

  describe '#piece_at' do
    let(:white_pawn1) { Pawn.new(:white) }

    before do
      board.place_piece(white_pawn1, [1, 1])
    end

    it 'returns the piece at the given position' do
      expect(board.piece_at([1, 1])).to be(white_pawn1)
    end

    it 'returns nil if the position is invalid' do
      expect(board.piece_at([9, 9])).to be_nil
    end
  end

  describe '#position_of' do
    let(:white_pawn1) { Pawn.new(:white) }

    before do
      board.place_piece(white_pawn1, [1, 1])
    end

    it 'returns the position of the given piece' do
      expect(board.position_of(white_pawn1)).to eq([1, 1])
    end

    it 'returns nil if the piece is not on the board' do
      expect(board.position_of(Pawn.new(:white))).to be_nil
    end

    it 'raises an error if argument is not a piece' do
      expect { board.position_of('not a piece') }.to raise_error(NoPieceError)
    end
  end

  describe '#pieces_of_color' do
    let(:white_pawn1) { Pawn.new(:white) }
    let(:white_pawn2) { Pawn.new(:white) }
    let(:white_pawn3) { Pawn.new(:white) }
    let(:black_pawn1) { Pawn.new(:black) }
    let(:black_pawn2) { Pawn.new(:black) }
    let(:black_pawn3) { Pawn.new(:black) }

    before do
      board.place_piece(white_pawn1, [1, 1])
      board.place_piece(white_pawn2, [2, 2])
      board.place_piece(white_pawn3, [3, 3])
      board.place_piece(black_pawn1, [4, 4])
      board.place_piece(black_pawn2, [5, 5])
      board.place_piece(black_pawn3, [6, 6])
    end

    it 'returns an array of pieces of the given color' do
      expect(board.pieces_of_color(:white).size).to eq(3)
      expect(board.pieces_of_color(:white).include?(white_pawn1)).to be(true)
      expect(board.pieces_of_color(:white).include?(white_pawn2)).to be(true)
      expect(board.pieces_of_color(:white).include?(white_pawn3)).to be(true)
      expect(board.pieces_of_color(:black).size).to eq(3)
      expect(board.pieces_of_color(:black).include?(black_pawn1)).to be(true)
      expect(board.pieces_of_color(:black).include?(black_pawn2)).to be(true)
      expect(board.pieces_of_color(:black).include?(black_pawn3)).to be(true)
    end
  end

  describe '#friendly_pieces_of_type' do
    let(:white_pawn1) { Pawn.new(:white) }
    let(:white_pawn2) { Pawn.new(:white) }
    let(:white_pawn3) { Pawn.new(:white) }
    let(:black_pawn1) { Pawn.new(:black) }
    let(:black_pawn2) { Pawn.new(:black) }
    let(:black_pawn3) { Pawn.new(:black) }

    before do
      board.place_piece(white_pawn1, [1, 1])
      board.place_piece(white_pawn2, [2, 2])
      board.place_piece(white_pawn3, [3, 3])
      board.place_piece(black_pawn1, [4, 4])
      board.place_piece(black_pawn2, [5, 5])
      board.place_piece(black_pawn3, [6, 6])
    end

    it 'returns an array of friendly pieces of the given type' do
      expect(board.friendly_pieces_of_type(:pawn, :white).size).to eq(3)
      expect(board.friendly_pieces_of_type(:pawn, :white).include?(white_pawn1)).to be(true)
      expect(board.friendly_pieces_of_type(:pawn, :white).include?(white_pawn2)).to be(true)
      expect(board.friendly_pieces_of_type(:pawn, :white).include?(white_pawn3)).to be(true)
      expect(board.friendly_pieces_of_type(:pawn, :black).size).to eq(3)
      expect(board.friendly_pieces_of_type(:pawn, :black).include?(black_pawn1)).to be(true)
      expect(board.friendly_pieces_of_type(:pawn, :black).include?(black_pawn2)).to be(true)
      expect(board.friendly_pieces_of_type(:pawn, :black).include?(black_pawn3)).to be(true)
    end
  end

  describe '#find_king' do
    let(:white_king) { King.new(:white) }
    let(:black_king) { King.new(:black) }

    before do
      board.place_piece(white_king, [1, 1])
      board.place_piece(black_king, [2, 2])
    end

    it 'returns the king of the given color' do
      expect(board.find_king(:white)).to be(white_king)
      expect(board.find_king(:black)).to be(black_king)
    end
  end

  describe '#set_up_board' do
    before do
      board.set_up_board
    end

    def test_piece_placement(piece_type, positions)
      positions.each do |pos|
        row, col = pos
        piece = board.piece_at([row, col])
        color = row < 2 ? :black : :white

        expect(piece).to be_a(Object.const_get(piece_type.to_s.capitalize))
        expect(piece.color).to eq(color)
      end
    end

    it 'puts 32 pieces on the board' do
      expect(board.active_pieces.size).to eq(32)
    end

    it 'puts 16 pieces of each color on the board' do
      expect(board.pieces_of_color(:white).size).to eq(16)
      expect(board.pieces_of_color(:black).size).to eq(16)
    end

    PIECES.each do |piece|
      it "puts #{piece[:count]} #{piece[:type]}s of each color on the board" do
        expect(board.friendly_pieces_of_type(piece[:type], :white).size).to eq(piece[:count])
        expect(board.friendly_pieces_of_type(piece[:type], :black).size).to eq(piece[:count])
      end

      it "puts #{piece[:type]}s in the correct starting positions" do
        test_piece_placement(piece[:type], piece[:starting_positions]) if piece[:starting_positions]
      end
    end
  end

  describe '#square_under_attack?' do
    before do
      board.place_piece(Pawn.new(:white), [6, 1])
      board.place_piece(Pawn.new(:black), [5, 1])
    end

    context 'when the square is not under attack' do
      it 'returns false' do
        expect(board.square_under_attack?([6, 1], :white)).to be(false)
        expect(board.square_under_attack?([5, 1], :black)).to be(false)
      end

      it 'does not change the board' do
        expect { board.square_under_attack?([6, 1], :white) }.not_to(change { board.active_pieces })
      end
    end

    context 'when the square is under attack' do
      it 'returns true' do
        expect(board.square_under_attack?([5, 2], :black)).to be(true)
        expect(board.square_under_attack?([6, 0], :white)).to be(true)
      end

      it 'does not change the board' do
        expect { board.square_under_attack?([5, 2], :black) }.not_to(change { board.active_pieces })
        expect { board.square_under_attack?([6, 0], :white) }.not_to(change { board.active_pieces })
      end
    end
  end
end
