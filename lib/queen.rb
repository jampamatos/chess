# frozen_string_literal: true

require_relative 'piece'
require 'colorize'

class Queen < Piece
  def initialize(color, position)
    symbol = color == :white ? '♕'.colorize(color) : '♛'.colorize(color)
    super(color, :queen, position, symbol)
  end
end
