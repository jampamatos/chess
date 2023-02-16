# frozen_string_literal: true

require_relative '../piece'
require 'colorize'

class Knight < Piece
  def initialize(color)
    symbol = color == :white ? '♘'.colorize(color) : '♞'.colorize(color)
    super(color, :knight, symbol)
  end

  def to_unicode
    @color == 'white' ? " \u2658 " : " \u265E "
  end

  def possible_moves(board, position = @position)
    current_row, current_col = position

    # Calculate all potential moves
    potential_moves = [[current_row + 2, current_col + 1],
                       [current_row + 2, current_col - 1],
                       [current_row - 2, current_col + 1],
                       [current_row - 2, current_col - 1],
                       [current_row + 1, current_col + 2],
                       [current_row + 1, current_col - 2],
                       [current_row - 1, current_col + 2],
                       [current_row - 1, current_col - 2]]

    # Only keep moves that are on the board and either unoccupied or occupied by an enemy piece
    potential_moves.select { |move| valid_position?(move) && (board[move].nil? || board[move].color != @color) }
  end
end
