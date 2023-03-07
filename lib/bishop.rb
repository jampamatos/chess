# frozen_string_literal: true

require_relative 'piece'
require 'colorize'

class Bishop < Piece
  def initialize(color)
    symbol = color == :white ? '♗'.colorize(color) : '♝'.colorize(color)
    super(color, :bishop, symbol)
  end

  def to_unicode
    @color == 'white' ? " \u2657 " : " \u265D "
  end
end
