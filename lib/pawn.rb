# frozen_string_literal: true

require_relative 'piece'
require 'colorize'

class Pawn < Piece
  def initialize(color, moved = false)
    symbol = color == :white ? '♙'.colorize(color) : '♟'.colorize(color)
    super(color, :pawn, symbol)
    @moved = moved
  end

  def to_unicode
    @color == 'white' ? " \u2659 " : " \u265F "
  end
end
