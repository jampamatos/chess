# frozen_string_literal: true

require_relative 'dependencies'

class Board
  attr_reader :grid, :active_pieces

  def initialize(grid = new_grid, active_pieces = {})
    @grid = grid
    @active_pieces = active_pieces
  end

  def add_piece(piece, position)
    row, col = position

    raise PositionNotEmptyError, position unless @grid[row][col].nil?

    @grid[row][col] = piece
    piece.position = position
    add_active_piece(piece) unless @active_pieces.value?(piece)
  end

  def remove_piece(position)
    piece = piece_at(position)
    remove_active_pieces(piece)
    @grid[position[0]][position[1]] = nil
  end

  def move_piece(piece, destination)
    remove_piece(piece.position)
    add_piece(piece, destination)
  end

  def valid_position?(position)
    row, col = position
    row.between?(0, 7) && col.between?(0, 7)
  end

  def piece_at(position)
    row, col = position
    @grid[row][col]
  end

  def position_of(piece)
    piece.position
  end

  def pieces_of_color(color)
    @active_pieces.select { |_k, piece| piece.color == color }.values
  end

  private

  def new_grid
    Array.new(8) { Array.new(8, nil) }
  end

  def piece_key(piece)
    new_key = "#{piece.color.downcase}_#{piece.type.downcase}"
    if piece.type == 'queen' || piece.type == 'king'
      new_key
    else
      count = 1
      count += 1 while @active_pieces.key?(new_key + count.to_s)
      "#{new_key}#{count}"
    end
  end

  def add_active_piece(piece)
    @active_pieces[piece_key(piece)] = piece
  end

  def remove_active_pieces(piece)
    @active_pieces.delete_if { |_, v| v == piece }
  end
end
