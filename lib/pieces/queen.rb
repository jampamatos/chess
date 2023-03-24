# frozen_string_literal: true

require_relative '../piece'

class Queen < Piece
  def initialize(color)
    symbol = color == :white ? '♛' : '♛'.colorize(color)
    super(color, :queen, symbol)
  end

  def possible_moves(board)
    moves = []

    moves.concat(move_generator(board, 7, 1, 0))
    moves.concat(move_generator(board, 7, -1, 0))
    moves.concat(move_generator(board, 7, 0, 1))
    moves.concat(move_generator(board, 7, 0, -1))

    moves.concat(move_generator(board, 7, 1, 1))
    moves.concat(move_generator(board, 7, -1, -1))
    moves.concat(move_generator(board, 7, 1, -1))
    moves.concat(move_generator(board, 7, -1, 1))

    moves
  end
end