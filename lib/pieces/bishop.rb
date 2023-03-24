# frozen_string_literal: true

require_relative '../piece'

class Bishop < Piece
  def initialize(color)
    symbol = color == 'white' ? '♗' : '♝'
    super(color, 'bishop', symbol)
  end

  def possible_moves(board)
    moves = []

    moves.concat(move_generator(board, 7, 1, 1))
    moves.concat(move_generator(board, 7, -1, -1))
    moves.concat(move_generator(board, 7, 1, -1))
    moves.concat(move_generator(board, 7, -1, 1))

    moves
  end
end