# frozen_string_literal: true

require_relative 'piece'
require 'colorize'

class Pawn < Piece
  def initialize(color, position, moved = false)
    symbol = color == :white ? '♙'.colorize(color) : '♟'.colorize(color)
    super(color, :pawn, position, symbol)
    @moved = moved
  end
end
