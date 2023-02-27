# frozen_string_literal: true

class Piece
  def initialize(color, type, position, symbol)
    @color = color
    @type = type
    @position = position
    @symbol = symbol
  end

  def to_s
    @symbol
  end

  def moves; end

  def move_to(position); end

  def valid_move?; end

  private

  def attack(position); end
end
