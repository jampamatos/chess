# frozen_string_literal: true

require_relative 'dependencies'

class BoardRender
  BG_COLOR_EVEN = :light_blue
  BG_COLOR_ODD = :blue

  def initialize(board)
    @board = board
  end

  def draw_board
    puts "\n   A  B  C  D  E  F  G  H\n"
    @board.grid.each_with_index { |row, i| print_row(row, i) }
    puts "\n   A  B  C  D  E  F  G  H\n"
  end

  private

  def print_row(row, i)
    print "#{8 - i} "
    row.each_with_index do |piece, j|
      bg_color = (i + j).even? ? BG_COLOR_EVEN : BG_COLOR_ODD
      print piece ? " #{piece} ".colorize(background: bg_color) : '   '.colorize(background: bg_color)
    end
    print " #{8 - i}\n"
  end
end
