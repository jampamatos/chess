# frozen_string_literal: true

require 'colorize'

class Square
  WHITE_COLOR = :cyan
  BLACK_COLOR = :blue
  YELLOW_COLOR = :light_yellow

  attr_reader :piece, :color, :selected

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

  def add_piece(piece)
    @piece = piece unless occupied?
  end

  def remove_piece
    @piece = nil if occupied?
  end

  def select
    @selected = true unless @selected
  end

  def deselect
    @selected = false if @selected
  end

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