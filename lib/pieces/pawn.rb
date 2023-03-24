# frozen_string_literal: true

require_relative '../piece'

class Pawn < Piece
  def initialize(color)
    symbol = color == 'white' ? '♙' : '♟︎'
    super(color, 'pawn', symbol)
  end

  def possible_moves(board)
    forward_moves(board) + diagonal_captures(board)
  end

  private

  def forward_moves(board)
    step = @moved ? 1 : 2
    direction = @color == 'white' ? -1 : 1

    move_generator(board, step, direction, 0)
  end

  def diagonal_captures(board)
    direction = @color == 'white' ? -1 : 1
    [-1, 1].map do |col_offset|
      target_row = position[0] + direction
      target_col = position[1] + col_offset
      target_position = [target_row, target_col]

      next unless board.valid_position?(target_position)

      target_piece = board.piece_at(target_position)
      p target_piece
      target_piece && !target_piece.same_color_as(self) ? target_position : nil
    end.compact
  end
end
