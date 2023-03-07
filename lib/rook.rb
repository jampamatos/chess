# frozen_string_literal: true

require_relative 'piece'
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

  private

  def horizontal_and_vertical_moves(board, position, row_step, col_step)
    moves = []
    current_row, current_col = position

    (1..7).each do |i|
      row = current_row + i * row_step
      col = current_col + i * col_step
      break unless valid_position?([row, col])

      destination = [row, col]
      if can_move_horizontally_or_vertically?(position, destination, board)
        moves << destination
        break unless board[destination].nil?
      else
        break
      end
    end

    moves.sort_by! { |move| [-move[0], move[1]] }

    moves
  end

  def can_move_horizontally_or_vertically?(position, destination, board)
    dest_row, dest_col = destination
    curr_row, curr_col = position

    if dest_row == curr_row
      min_col, max_col = [curr_col, dest_col].minmax
      (min_col + 1...max_col).each do |col|
        if board[[curr_row, col]].nil?
          next
        elsif board[[curr_row, col]].color != @color
          return true
        else
          return false
        end
      end
    elsif dest_col == curr_col
      min_row, max_row = [curr_row, dest_row].minmax
      (min_row + 1...max_row).each do |row|
        if board[[row, curr_col]].nil?
          next
        elsif board[[row, curr_col]].color != @color
          return true
        else
          return false
        end
      end
    else
      return false
    end

    true
  end
end
