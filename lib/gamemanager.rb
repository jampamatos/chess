# frozen_string_literal: true

require_relative 'dependencies'

class GameManager
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
    8.times do |i|
      pawns << Pawn.new(color.to_s)
      self.instance_variable_set("@#{color}_pawn#{i+1}", pawns[i])
    end
  end

  def create_rooks(color)
    rooks = []
    2.times do |i|
      rooks << Rook.new(color.to_s)
      self.instance_variable_set("@#{color}_rook#{i+1}", rooks[i])
    end
  end

  def create_knights(color)
    knights = []
    2.times do |i|
      knights << Knight.new(color.to_s)
      self.instance_variable_set("@#{color}_knight#{i+1}", knights[i])
    end
  end

  def create_bishops(color)
    bishops = []
    2.times do |i|
      bishops << Bishop.new(color.to_s)
      self.instance_variable_set("@#{color}_bishop#{i+1}", bishops[i])
    end
  end

  def create_queen(color)
    self.instance_variable_set("@#{color}_queen", Queen.new(color))
  end

  def create_king(color)
    self.instance_variable_set("@#{color}_king", King.new(color))
  end
end
