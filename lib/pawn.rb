# frozen_string_literal: true

require_relative 'piece'
require 'colorize'

class Pawn < Piece
  def initialize(color, moved = false)
    symbol = color == :white ? '♙'.colorize(color) : '♟'.colorize(color)
    super(color, :pawn, symbol)
    @moved = moved
  end

  def to_unicode
    @color == 'white' ? " \u2659 " : " \u265F "
  end

  def possible_moves(board, position = @position)
    moves = []

    row, col = position

    # Determine the direction and distance the pawn can move
    direction = color == :white ? -1 : 1
    step_one = [row + direction, col]
    step_two = [row + 2 * direction, col]
    diagonal_left = [row + direction, col - 1]
    diagonal_right = [row + direction, col + 1]

    # Check if step one is a valid move
    if board[step_one].nil?
      moves << step_one
      moves << step_two if !moved && board[step_two].nil?
    end

    # Check if diagonal left is a valid move
    if col > 0
      piece = board[diagonal_left]
      if piece && piece.color != color
        moves << diagonal_left
      elsif board.en_passant == diagonal_left
        moves << diagonal_left
      end
    end

    # Check if diagonal right is a valid move
    if col < 7
      piece = board[diagonal_right]
      if piece && piece.color != color
        moves << diagonal_right
      elsif board.en_passant == diagonal_right
        moves << diagonal_right
      end
    end

    moves
  end
end
