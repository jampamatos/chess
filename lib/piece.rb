# frozen_string_literal: true

require 'colorize'

class Piece

  attr_reader :color, :type, :symbol, :moved
  attr_accessor :position

  def initialize(color, type, symbol, position = nil)
    @color = color
    @type = type
    @symbol = symbol
    @position = position
    @moved = false
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

  def move(destination, board)
    return false unless possible_moves(board).include?(destination)

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
    puts "@moved before: #{@moved}"
    @moved = true
    puts "@moved after: #{@moved}"

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
end
