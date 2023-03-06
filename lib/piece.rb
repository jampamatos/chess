# frozen_string_literal: true

require 'colorize'

class Piece

  attr_reader :color, :type
  attr_accessor :position

  def initialize(color, type, symbol, position = nil)
    @color = color
    @type = type
    @symbol = symbol
    @position = position
  end

  def to_s
    @symbol.colorize(color)
  end

  def possible_moves(_board, _position = @position)
    []
  end

  def move_to(position); end

  def valid_move?; end

  private

  def attack(position); end
end
