# frozen_string_literal: true

require 'colorize'

class Square
  WHITE_COLOR = :cyan
  BLACK_COLOR = :blue
  YELLOW_COLOR = :light_yellow

  def initialize(x, y, color, piece = nil, selected = false)
    @x = x
    @y = y
    @color = color
    @piece = piece
    @selected = selected
  end

  def occupied?
    !@piece.nil?
  end

  def to_s
    if occupied?
      background_color = @selected ? :light_yellow : color_to_background(@color)
      symbol = @piece.symbol
      square_drawn(symbol).colorize(background: background_color)
    elsif @selected
      square_drawn.colorize(background: :light_yellow)
    else
      square_drawn.colorize(background: color_to_background(@color))
    end
  end

  def set_piece; end

  def remove_piece; end

  def select; end

  def deselect; end

  def reachable_by?(piece); end

  def attacked_by?(piece); end

  private

  def color_to_background(color)
    case color
    when WHITE_COLOR then :cyan
    when BLACK_COLOR then :blue
    when YELLOW_COLOR then :light_yellow
    end
  end

  def square_drawn(symbol = ' ')
    "         \n"+
    "    #{symbol}    \n"+
    "         "
  end
end