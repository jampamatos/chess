# frozen_string_literal: true

require_relative 'piece'
require 'colorize'

class Rook < Piece
  def initialize(color)
    symbol = color == :white ? '♖'.colorize(color) : '♜'.colorize(color)
    super(color, :rook, symbol)
  end
end
