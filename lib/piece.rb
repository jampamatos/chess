# frozen_string_literal: true

require 'colorize'

class Piece

  attr_reader :color, :type, :symbol
  attr_accessor :position

  def initialize(color, type, symbol, position = nil)
    @color = color
    @type = type
    @symbol = symbol
    @position = position
  end

  def to_s
    @symbol.colorize(color)
  end

  def possible_moves(_board, _position = @position)
    []
  end

  def to_chess_notation(row, col, symbol = @symbol)
    file = ('a'..'h').to_a[col]
    rank = 8 - row
    "#{symbol}#{file}#{rank}"
  end

  def move_to(position); end

  def valid_move?; end

  private

  def attack(position); end
end
