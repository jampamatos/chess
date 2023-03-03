# frozen_string_literal: true

require_relative '../lib/gamemanager'

describe GameManager do
  describe "#initialize" do
    it "creates a new board" do
      game = GameManager.new
      expect(game.instance_variable_get("@board")).to be_a(Board)
    end

    it "creates white and black pieces" do
      game = GameManager.new
      white_pawn = game.instance_variable_get("@white_pawn1")
      black_pawn = game.instance_variable_get("@black_pawn1")
      expect(white_pawn).to be_a(Pawn)
      expect(black_pawn).to be_a(Pawn)
    end

    it "creates the correct number of pieces" do
      game = GameManager.new
      white_pieces = []
      black_pieces = []

      # Collect all white and black pieces
      game.instance_variables.each do |var|
        piece = game.instance_variable_get(var)
        if var.to_s.start_with?("@white_")
          white_pieces << piece
          puts "White piece found: #{var}"
        elsif var.to_s.start_with?("@black_")
          black_pieces << piece
          puts "Black piece found: #{var}"
        end
      end

      # Check that the correct number of pieces were created
      expect(white_pieces.size).to eq(16)
      expect(black_pieces.size).to eq(16)
    end
  end
end

