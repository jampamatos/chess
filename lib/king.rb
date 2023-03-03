# frozen_string_literal: true

require_relative 'piece'
require 'colorize'

class King < Piece
  def initialize(color, position)
    symbol = color == :white ? '♔'.colorize(color) : '♚'.colorize(color)
    super(color, :king, position, symbol)
  end
end