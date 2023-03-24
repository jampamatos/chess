# frozen_string_literal: true

require_relative '../piece'

class King < Piece
  def initialize(color)
    symbol = color == 'white' ? '♔' : '♚'
    super(color, 'king', symbol)
  end

  def possible_moves(board)
    moves = []

    moves.concat(move_generator(board, 1, 1, 0))
    moves.concat(move_generator(board, 1, -1, 0))
    moves.concat(move_generator(board, 1, 0, 1))
    moves.concat(move_generator(board, 1, 0, -1))

    moves.concat(move_generator(board, 1, 1, 1))
    moves.concat(move_generator(board, 1, -1, -1))
    moves.concat(move_generator(board, 1, 1, -1))
    moves.concat(move_generator(board, 1, -1, 1))

    moves
  end
end