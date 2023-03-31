# frozen_string_literal: true

require_relative '../piece'

class Knight < Piece
  def initialize(color)
    symbol = color == :white ? '♞' : '♞'.colorize(color)
    super(color, :knight, symbol)
  end

  def possible_moves(board)
    curr_row, curr_col = position

    row_offsets = [2, 1, -1, -2, -2, -1, 1, 2]
    col_offsets = [1, 2, 2, 1, -1, -2, -2, -1]

    potential_moves = row_offsets.zip(col_offsets).map do |row_offset, col_offset|
      [curr_row + row_offset, curr_col + col_offset]
    end

    potential_moves.select do |move|
      board.valid_position?(move) && (!board.piece_at(move) || !board.piece_at(move).same_color_as(self))
    end
  end
end