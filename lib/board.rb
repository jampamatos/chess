# frozen_string_literal: true

BG_COLOR = :light_black

class Board
  attr_accessor :grid

  def initialize
    @grid = Array.new(8) { Array.new(8, nil) }
  end

  def set_piece(piece, position)
    row, col = position
    old_position = piece.position

    raise "Cannot set piece: position #{position} is not empty" unless @grid[row][col] == nil

    @grid[row][col] = piece
    piece.position = position

    if old_position
      old_row, old_col = old_position
      @grid[old_row][old_col] = nil
    end
  end

  def [](position)
    row, col = position
    @grid[row][col]
  end

  def draw_board
    puts "\n   A  B  C  D  E  F  G  H\n"
    @grid.each_with_index do |row, i|
      print "#{8 - i} "
      row.each_with_index do |piece, j|
        bg_color = (i + j).even? ? BG_COLOR : :default
        print piece ? piece.to_unicode.colorize(background: bg_color) : '  '.colorize(background: bg_color)
      end
      print " #{8 - i}\n"
    end
    puts "\n   A  B  C  D  E  F  G  H\n"
  end
end
