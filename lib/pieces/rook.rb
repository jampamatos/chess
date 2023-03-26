# frozen_string_literal: true

require_relative '../piece'

class Rook < Piece
  def initialize(color)
    symbol = color == 'white' ? '♖' : '♜'
    super(color, 'rook', symbol)
  end

  def possible_moves(board)
    moves = []

    moves.concat(move_generator(board, 7, 1, 0))
    moves.concat(move_generator(board, 7, -1, 0))
    moves.concat(move_generator(board, 7, 0, 1))
    moves.concat(move_generator(board, 7, 0, -1))

    moves
  end

  def can_castle?(board)
    return false if @moved

    left_square = [position[0], position[1] - 1]
    right_square = [position[0], position[1] + 1]

    return true if board.valid_position?(left_square) && board.piece_at(left_square).nil?

    return true if board.valid_position?(right_square) && board.piece_at(right_square).nil?

    false
  end
end