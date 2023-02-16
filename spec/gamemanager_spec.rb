# frozen_string_literal: true

require_relative '../lib/gamemanager'

describe GameManager do
  describe "#initialize" do
    it "creates a new board" do
      game = GameManager.new
      expect(game.instance_variable_get('@board')).to be_a(Board)
    end

    it "creates white and black pieces" do
      game = GameManager.new
      white_pawn = game.active_pieces['white_pawn1']
      black_pawn = game.active_pieces['black_pawn1']
      expect(white_pawn).to be_a(Pawn)
      expect(black_pawn).to be_a(Pawn)
    end

    it "creates the correct number of pieces" do
      game = GameManager.new
      white_pieces = []
      black_pieces = []

      game.active_pieces.each do |_name, piece|
        if piece.color == 'white'
          white_pieces << piece
        elsif piece.color == 'black'
          black_pieces << piece
        end
      end

      # Check that the correct number of pieces were created
      expect(white_pieces.size).to eq(16)
      expect(black_pieces.size).to eq(16)
    end

    describe "piece positions" do
      let(:board) { GameManager.new.instance_variable_get("@board") }

      it "places white rooks correctly" do
        expect(board.grid[7][0]).to be_an_instance_of(Rook)
        expect(board.grid[7][0].color).to eq("white")
        expect(board.grid[7][7]).to be_an_instance_of(Rook)
        expect(board.grid[7][7].color).to eq("white")
      end

      it "places black rooks correctly" do
        expect(board.grid[0][0]).to be_an_instance_of(Rook)
        expect(board.grid[0][0].color).to eq("black")
        expect(board.grid[0][7]).to be_an_instance_of(Rook)
        expect(board.grid[0][7].color).to eq("black")
      end

      it "places white knights correctly" do
        expect(board.grid[7][1]).to be_an_instance_of(Knight)
        expect(board.grid[7][1].color).to eq("white")
        expect(board.grid[7][6]).to be_an_instance_of(Knight)
        expect(board.grid[7][6].color).to eq("white")
      end

      it "places black knights correctly" do
        expect(board.grid[0][1]).to be_an_instance_of(Knight)
        expect(board.grid[0][1].color).to eq("black")
        expect(board.grid[0][6]).to be_an_instance_of(Knight)
        expect(board.grid[0][6].color).to eq("black")
      end

      it "places white bishops correctly" do
        expect(board.grid[7][2]).to be_an_instance_of(Bishop)
        expect(board.grid[7][2].color).to eq("white")
        expect(board.grid[7][2]).to be_an_instance_of(Bishop)
        expect(board.grid[7][2].color).to eq("white")
      end

      it "places black bishops correctly" do
        expect(board.grid[0][2]).to be_an_instance_of(Bishop)
        expect(board.grid[0][2].color).to eq("black")
        expect(board.grid[0][5]).to be_an_instance_of(Bishop)
        expect(board.grid[0][5].color).to eq("black")
      end

      it "places white queen correctly" do
        expect(board.grid[7][3]).to be_an_instance_of(Queen)
        expect(board.grid[7][3].color).to eq("white")
      end

      it "places black queen correctly" do
        expect(board.grid[0][3]).to be_an_instance_of(Queen)
        expect(board.grid[0][3].color).to eq("black")
      end

      it "places white king correctly" do
        expect(board.grid[7][4]).to be_an_instance_of(King)
        expect(board.grid[7][4].color).to eq("white")
      end

      it "places black king correctly" do
        expect(board.grid[0][4]).to be_an_instance_of(King)
        expect(board.grid[0][4].color).to eq("black")
      end
    end
  end
end
