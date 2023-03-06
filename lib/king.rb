# frozen_string_literal: true

require_relative 'piece'
require 'colorize'

class King < Piece
  def initialize(color)
    symbol = color == :white ? '♔'.colorize(color) : '♚'.colorize(color)
    super(color, :king, symbol)
  end

  def to_unicode
    @color == 'white' ? "\u2654 " : "\u265A "
  end
end