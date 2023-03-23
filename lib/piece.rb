# frozen_string_literal: true

class Piece
  attr_accessor :color, :type, :position

  def initialize(color, type, position = nil)
    @color = color
    @type = type
    @position = position
  end
end