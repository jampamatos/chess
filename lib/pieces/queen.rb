# frozen_string_literal: true

require_relative '../piece'
require 'colorize'

class Queen < Piece
  def initialize(color)
    symbol = color == :white ? '♕'.colorize(color) : '♛'.colorize(color)
    super(color, :queen, symbol)
  end

  def to_unicode
    @color == 'white' ? " \u2655 " : " \u265B "
  end

  def possible_moves(board, position = @position)
    moves = []

    moves += horizontal_and_vertical_moves(board, position, 1, 0)
    moves += horizontal_and_vertical_moves(board, position, -1, 0)
    moves += horizontal_and_vertical_moves(board, position, 0, 1)
    moves += horizontal_and_vertical_moves(board, position, 0, -1)
    moves += diagonal_moves(board, position, 1, 1)
    moves += diagonal_moves(board, position, 1, -1)
    moves += diagonal_moves(board, position, -1, 1)
    moves += diagonal_moves(board, position, -1, -1)

    moves
  end
end
