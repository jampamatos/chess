# frozen_string_literal: true

require_relative 'piece'
require 'colorize'

class Queen < Piece
  def initialize(color)
    symbol = color == :white ? '♕'.colorize(color) : '♛'.colorize(color)
    super(color, :queen, symbol)
  end

  def to_unicode
    @color == 'white' ? "\u2655 " : "\u265B "
  end
end
