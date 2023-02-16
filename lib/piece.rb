# frozen_string_literal: true

require 'colorize'

class Piece
  attr_reader :color, :type, :symbol, :selected
  attr_accessor :position, :moved

  def initialize(color, type, symbol, position = nil)
    @color = color
    @type = type
    @symbol = symbol
    @position = position
    @moved = false
    @selected = false
  end

  def to_s
    @symbol.colorize(color)
  end

  def to_chess_notation(row, col, symbol = @symbol)
    file = ('a'..'h').to_a[col]
    rank = 8 - row
    "#{symbol}#{file}#{rank}"
  end

  def possible_moves(_board, _position = @position)
    []
  end

  def select
    @selected = true
  end

  def deselect
    @selected = false
  end

  def move(destination, board, _game_manager = nil)
    unless possible_moves(board).include?(destination)
      raise InvalidMoveError, "Invalid move for #{self.class} at #{to_chess_notation(position[0], position[1])} to #{to_chess_notation(destination[0], destination[1])}"
    end

    row, col = destination
    prev_row, prev_col = @position
    piece = board[destination]
    capture = ''
    if piece && piece.color != @color
      board.remove_piece(destination)
      capture = "x#{to_chess_notation(row, col, piece.symbol)}"
    end

    board.set_piece(self, destination)
    @position = destination
    @moved = true
    board.en_passant = nil

    if capture.to_s.strip.empty?
      "#{to_chess_notation(position[0], position[1])}"
    else
      "#{to_chess_notation(prev_row, prev_col)}#{capture}"
    end
  end

  private

  def valid_position?(position)
    row, col = position
    row.between?(0, 7) && col.between?(0, 7)
  end

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

  def diagonal_moves(board, position, row_step, col_step)
    moves = []
    current_row, current_col = position

    (1..7).each do |i|
      row = current_row + i * row_step
      col = current_col + i * col_step
      break unless valid_position?([row, col])

      destination = [row, col]
      if can_move_diagonally?(position, destination, board)
        moves << destination
        break unless board[destination].nil?
      else
        break
      end
    end

    moves
  end

  def can_move_horizontally_or_vertically?(position, destination, board)
    dest_row, dest_col = destination
    curr_row, curr_col = position
  
    if dest_row == curr_row
      min_col, max_col = [curr_col, dest_col].minmax
      (min_col + 1...max_col).each do |col|
        return false unless board[[curr_row, col]].nil?
      end
    elsif dest_col == curr_col
      min_row, max_row = [curr_row, dest_row].minmax
      (min_row + 1...max_row).each do |row|
        return false unless board[[row, curr_col]].nil?
      end
    else
      return false
    end
  
    dest_piece = board[destination]
    dest_piece.nil? || dest_piece.color != @color
  end

  def can_move_diagonally?(position, destination, board)
    dest_row, dest_col = destination
    curr_row, curr_col = position

    if (dest_row - curr_row).abs == (dest_col - curr_col).abs
      row_step = dest_row > curr_row ? 1 : -1
      col_step = dest_col > curr_col ? 1 : -1

      row, col = curr_row + row_step, curr_col + col_step
      while row != dest_row || col != dest_col
        return false unless board[[row, col]].nil?

        row += row_step
        col += col_step
      end

      dest_piece = board[destination]

      return true if dest_piece.nil? || dest_piece.color != @color
    end

    false
  end
end

class InvalidMoveError < StandardError
end
