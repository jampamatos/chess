# frozen_string_literal: true

require_relative '../piece'

class King < Piece
  include BoardSetup

  def initialize(color, in_check: false)
    symbol = color == :white ? '♚' : '♚'.colorize(color)
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
    all_moves(board)
      .reject { |move| board.king_move_will_put_it_in_check?(self, move) }
      .select { |move| valid_king_move?(board, move) }
  end

  def all_moves(board)
    moves = king_move_generator(board)
    moves.concat(castling_move(board))
    moves
  end

  def castling_move(board)
    return [] if @moved || in_check?

    row = BoardSetup.pieces_rank(@color)
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
    return false unless rook&.moved == false

    col_range.all? { |i| board.piece_at([row, i]).nil? && !board.square_under_attack?([row, i], @color) }
  end

  def valid_king_move?(board, move)
    opponent_king = board.find_king(board.opposing_color(color))
    (move[0] - opponent_king.position[0]).abs > 1 || (move[1] - opponent_king.position[1]).abs > 1
  end

  def king_move_generator(board)
    moves = []
    directions = [
      [1, 0], [-1, 0], [0, 1], [0, -1], # horizontal and vertical moves
      [1, 1], [-1, -1], [1, -1], [-1, 1] # diagonal moves
    ]

    directions.each do |row_increment, col_increment|
      moves.concat(move_generator(board, 1, row_increment, col_increment))
    end

    moves
  end
end
