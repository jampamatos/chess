# frozen_string_literal: true

require_relative 'piece'
require 'colorize'

class Bishop < Piece
  def initialize(color, position)
    symbol = color == :white ? '♗'.colorize(color) : '♝'.colorize(color)
    super(color, :bishop, position, symbol)
  end
end
