# frozen_string_literal: true

require_relative '../piece'
require 'colorize'

class Rook < Piece
  def initialize(color)
    symbol = color == :white ? '♖'.colorize(color) : '♜'.colorize(color)
    super(color, :rook, symbol)
  end

  def to_unicode
    @color == 'white' ? " \u2656 " : " \u265C "
  end

  def possible_moves(board, position = @position)
    moves = []

    moves += horizontal_and_vertical_moves(board, position, 1, 0) # Right
    moves += horizontal_and_vertical_moves(board, position, -1, 0) # Left
    moves += horizontal_and_vertical_moves(board, position, 0, 1) # Up
    moves += horizontal_and_vertical_moves(board, position, 0, -1) # Down

    moves
  end
end
