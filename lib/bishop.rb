# frozen_string_literal: true

require_relative 'piece'
require 'colorize'

class Bishop < Piece
  def initialize(color)
    symbol = color == :white ? '♗'.colorize(color) : '♝'.colorize(color)
    super(color, :bishop, symbol)
  end

  def to_unicode
    @color == 'white' ? " \u2657 " : " \u265D "
  end

  def possible_moves(board, position = @position)
    moves = []
    row, col = position

    # top-right diagonal
    i = 1
    while row - i >= 0 && col + i <= 7
      dest = [row - i, col + i]
      if can_move_diagonally?(position, dest, board)
        moves << dest
        break unless board[dest].nil?
      else
        break
      end
      i += 1
    end

    # top-left diagonal
    i = 1
    while row - i >= 0 && col - i >= 0
      dest = [row - i, col - i]
      if can_move_diagonally?(position, dest, board)
        moves << dest
        break unless board[dest].nil?
      else
        break
      end
      i += 1
    end

    # bottom-right diagonal
    i = 1
    while row + i <= 7 && col + i <= 7
      dest = [row + i, col + i]
      if can_move_diagonally?(position, dest, board)
        moves << dest
        break unless board[dest].nil?
      else
        break
      end
      i += 1
    end

    # bottom-left diagonal
    i = 1
    while row + i <= 7 && col - i >= 0
      dest = [row + i, col - i]
      if can_move_diagonally?(position, dest, board)
        moves << dest
        break unless board[dest].nil?
      else
        break
      end
      i += 1
    end

    moves.sort_by { |move| [-move[0], move[1]] }
  end

  private

  def can_move_diagonally?(position, destination, board)
    dest_row, dest_col = destination
    curr_row, curr_col = position

    if (dest_row - curr_row).abs == (dest_col - curr_col).abs
      min_row, max_row = [curr_row, dest_row].minmax
      min_col, max_col = [curr_col, dest_col].minmax

      (min_row + 1...max_row).each do |row|
        (min_col + 1...max_col).each do |col|
          return false unless board[[row, col]].nil?
        end
      end

      dest_piece = board[destination]

      return true if dest_piece.nil? || dest_piece.color != @color
    end

    false
  end
end
