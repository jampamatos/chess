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
        break if board[dest]
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
        break if board[dest]
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
        break if board[dest]
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
        break if board[dest]
      else
        break
      end
      i += 1
    end

    moves.sort_by { |move| [-move[0], move[1]] }
  end
end
