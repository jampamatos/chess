# frozen_string_literal: true

require_relative '../piece'

class King < Piece

  def initialize(color, in_check: false)
    symbol = color == :white ? '♔' : '♚'
    @in_check = in_check
    super(color, :king, symbol)
  end

  def in_check?
    @in_check
  end

  def mark_as_in_check
    @in_check = true
  end

  def mark_as_not_in_check
    @in_check = false
  end

  def possible_moves(board)
    all_moves(board)#.reject { |move| board.king_move_will_put_it_in_check?(self, move) }
  end

  def all_moves(board)
    moves = []

    moves.concat(move_generator(board, 1, 1, 0))
    moves.concat(move_generator(board, 1, -1, 0))
    moves.concat(move_generator(board, 1, 0, 1))
    moves.concat(move_generator(board, 1, 0, -1))

    moves.concat(move_generator(board, 1, 1, 1))
    moves.concat(move_generator(board, 1, -1, -1))
    moves.concat(move_generator(board, 1, 1, -1))
    moves.concat(move_generator(board, 1, -1, 1))

    moves.concat(special_moves(board))

    moves
  end

  def special_moves(board)
    return [] if @moved || in_check?

    row = board.pieces_rank(@color)
    col = @position[1]
    left_rook = board.find_rook_at([row, 0], color)
    right_rook = board.find_rook_at([row, 7], color)

    moves = []
    moves << [row, col - 2] if can_castle?(left_rook, board, row, 1..col - 1)
    moves << [row, col + 2] if can_castle?(right_rook, board, row, col + 1..6)

    moves
  end

  private

  def can_castle?(rook, board, row, col_range)
    return false unless rook&.can_castle?(board)

    col_range.all? { |i| board.piece_at([row, i]).nil? && !board.square_under_attack?([row, i], @color) }
  end
end
