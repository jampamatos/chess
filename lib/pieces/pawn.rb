# frozen_string_literal: true

require_relative '../piece'

class Pawn < Piece
  def initialize(color)
    symbol = color == :white ? '♟︎' : '♟︎'.colorize(color)
    super(color, :pawn, symbol)
  end

  def possible_moves(board)
    forward_moves(board) + diagonal_captures(board)
  end

  def can_promote?
    @color == :white && position[0].zero? || @color == :black && position[0] == 7
  end

  private

  def forward_blocked?(board, direction)
    board.piece_at([position[0] + direction, position[1]])
  end

  def forward_moves(board)
    direction = @color == :white ? -1 : 1
    one_step_forward = move_generator(board, 1, direction, 0)
    return one_step_forward if @moved || forward_blocked?(board, direction)

    two_steps_forward = forward_blocked?(board, direction * 2) ? [] : move_generator(board, 2, direction, 0)
    one_step_forward + two_steps_forward
  end

  def diagonal_captures(board)
    [-1, 1].each_with_object([]) do |col_offset, captures|
      target_position = capture_target_position(col_offset)
      next unless board.valid_position?(target_position)

      captures << target_position if valid_capture_or_en_passant?(board, target_position)
    end
  end

  def capture_target_position(col_offset)
    direction = @color == :white ? -1 : 1
    target_row = position[0] + direction
    target_col = position[1] + col_offset
    [target_row, target_col]
  end

  def valid_capture_or_en_passant?(board, target_position)
    target_piece = board.piece_at(target_position)
    valid_capture = target_piece && !target_piece.same_color_as(self)
    valid_en_passant = target_position == board.en_passant_target
    valid_capture || valid_en_passant
  end

  # This method generates the forward moves for the pawn
  def move_generator(board, step, row_offset, col_offset)
    target_row = position[0] + row_offset * step
    target_col = position[1] + col_offset * step
    target_position = [target_row, target_col]

    return [] unless board.valid_position?(target_position) && !forward_blocked?(board, row_offset * step)

    [target_position]
  end
end
