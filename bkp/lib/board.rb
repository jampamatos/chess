# frozen_string_literal: true

BG_COLOR = :light_black
SELECTED = :blue

class Board
  attr_accessor :grid, :en_passant, :active_pieces

  def initialize
    @grid = Array.new(8) { Array.new(8, nil) }
    @en_passant = nil
    @active_pieces = {}
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

  def remove_piece(position)
    piece = @grid[position[0]][position[1]]
    @grid[position[0]][position[1]] = nil
    @active_pieces.delete_if { |_, v| v == piece }
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
        print piece ? piece.to_unicode.colorize(background: bg_color) : '   '.colorize(background: bg_color)
      end
      print " #{8 - i}\n"
    end
    puts "\n   A  B  C  D  E  F  G  H\n"
  end

  def square_under_attack?(position, color, target_king)
    set_temporary_piece(color, position)

    @active_pieces.any? do |_, piece|
      next if piece.color == color || piece == target_king

      piece.possible_moves(self).include?(position)
    end.tap { remove_temporary_piece(position) }
  end

  private

  def set_temporary_piece(color, position)
    @grid[position[0]][position[1]] = Pawn.new(color, position)
    @active_pieces = active_pieces.merge({ "temp_#{color}_pawn" => @grid[position[0]][position[1]] })
  end

  def remove_temporary_piece(position)
    @grid[position[0]][position[1]] = nil
    @active_pieces.delete("temp_white_pawn")
    @active_pieces.delete("temp_black_pawn")
  end
end
