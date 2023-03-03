# frozen_string_literal: true

require_relative 'piece'
require 'colorize'

class Knight < Piece
  def initialize(color, position)
    symbol = color == :white ? '♘'.colorize(color) : '♞'.colorize(color)
    super(color, :knight, position, symbol)
  end
end
