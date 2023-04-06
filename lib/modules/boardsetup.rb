# frozen_string_literal: true

require_relative '../dependencies'

module BoardSetup
  PIECES_RANK = { white: 7, black: 0 }.freeze
  PAWNS_RANK = { white: 6, black: 1 }.freeze

  def self.pieces_rank(color)
    PIECES_RANK[color]
  end

  def self.pawns_rank(color)
    PAWNS_RANK[color]
  end

  def self.generate_pieces(board, color)
    generate_pawns(board, color)
    generate_rooks(board, color)
    generate_knights(board, color)
    generate_bishops(board, color)
    generate_queen(board, color)
    generate_king(board, color)
  end

  def self.generate_pawns(board, color)
    8.times do |col|
      position = [PAWNS_RANK[color], col]
      pawn = Pawn.new(color)
      board.place_piece(pawn, position)
    end
  end

  def self.generate_rooks(board, color)
    [0, 7].each do |col|
      position = [PIECES_RANK[color], col]
      rook = Rook.new(color)
      board.place_piece(rook, position)
    end
  end

  def self.generate_knights(board, color)
    [1, 6].each do |col|
      position = [PIECES_RANK[color], col]
      knight = Knight.new(color)
      board.place_piece(knight, position)
    end
  end

  def self.generate_bishops(board, color)
    [2, 5].each do |col|
      position = [PIECES_RANK[color], col]
      bishop = Bishop.new(color)
      board.place_piece(bishop, position)
    end
  end

  def self.generate_queen(board, color)
    position = [PIECES_RANK[color], 3]
    board.place_piece(Queen.new(color), position)
  end

  def self.generate_king(board, color)
    position = [PIECES_RANK[color], 4]
    board.place_piece(King.new(color), position)
  end
end
