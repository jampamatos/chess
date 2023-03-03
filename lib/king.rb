# frozen_string_literal: true

require_relative 'piece'
require 'colorize'

class King < Piece
  def initialize(color)
    symbol = color == :white ? '♔'.colorize(color) : '♚'.colorize(color)
    super(color, :king, symbol)
  end
end