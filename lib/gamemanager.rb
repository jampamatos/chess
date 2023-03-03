# frozen_string_literal: true

require_relative 'dependencies'

START_ROW = { 'white' => 7, 'black' => 0 }

class GameManager
  attr_reader :board

  def initialize
    @board = Board.new

    # create white pieces
    create_pieces('white')

    # create black pieces
    create_pieces('black')
  end

  private

  def create_pieces(color)
    create_pawns(color)
    create_rooks(color)
    create_knights(color)
    create_bishops(color)
    create_queen(color)
    create_king(color)
  end

  def create_pawns(color)
    pawns = []
    start_pawn_row = color == 'white' ? 6 : 1

    8.times do |i|
      position = [start_pawn_row, i]
      pawn = Pawn.new(color, position)
      pawns << pawn
      set_piece(pawn, position)
      self.instance_variable_set("@#{color}_pawn#{i+1}", pawn)
    end
  end

  def create_rooks(color)
    rooks = []
    2.times do |i|
      rook = Rook.new(color.to_s)
      rooks << rook
      set_piece(rook, [START_ROW[color], i == 0 ? 0 : 7])
      self.instance_variable_set("@#{color}_rook#{i+1}", rook)
    end
  end

  def create_knights(color)
    knights = []
    2.times do |i|
      knight = Knight.new(color.to_s)
      knights << knight
      set_piece(knight, [START_ROW[color], i == 0 ? 1 : 6])
      self.instance_variable_set("@#{color}_knight#{i+1}", knight)
    end
  end

  def create_bishops(color)
    bishops = []
    2.times do |i|
      bishop = Bishop.new(color.to_s)
      bishops << bishop
      set_piece(bishop, [START_ROW[color], i == 0 ? 2 : 5])
      self.instance_variable_set("@#{color}_bishop#{i+1}", bishop)
    end
  end

  def create_queen(color)
    queen = Queen.new(color)
    set_piece(queen, [START_ROW[color], 3])
    self.instance_variable_set("@#{color}_queen", queen)
  end
  
  def create_king(color)
    king = King.new(color)
    set_piece(king, [START_ROW[color], 4])
    self.instance_variable_set("@#{color}_king", king)
  end

  def set_piece(piece, position)
    row, col = position
    raise "Cannot set piece: position #{position} is not empty" unless @board.grid[row][col] == nil
  
    @board.grid[row][col] = piece
    piece.position = position
  end
end
