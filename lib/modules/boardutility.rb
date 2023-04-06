# frozen_string_literal: true

require_relative '../dependencies'

module BoardUtility

  def opposing_color(color)
    color == :white ? :black : :white
  end

  def valid_position?(position)
    row, col = position
    row.between?(0, 7) && col.between?(0, 7)
  end

  def switch_turn
    @turn = opposing_color(@turn)
  end
end