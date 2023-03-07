# frozen_string_literal: true

require_relative 'piece'
require 'colorize'

class Knight < Piece
  def initialize(color)
    symbol = color == :white ? '♘'.colorize(color) : '♞'.colorize(color)
    super(color, :knight, symbol)
  end

  def to_unicode
    @color == 'white' ? " \u2658 " : " \u265E "
  end
end
