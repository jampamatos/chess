# frozen_string_literal: true

require_relative '../piece'

class Rook < Piece
  def initialize(color)
    symbol = color == :white ? '♖' : '♜'
    super(color, :rook, symbol)
  end

  def possible_moves(board)
    moves = []

    moves.concat(move_generator(board, 7, 1, 0))
    moves.concat(move_generator(board, 7, -1, 0))
    moves.concat(move_generator(board, 7, 0, 1))
    moves.concat(move_generator(board, 7, 0, -1))

    moves
  end
end