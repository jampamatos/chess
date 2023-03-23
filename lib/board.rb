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

    raise InvalidPositionError, position unless valid_position?(position)
    raise PositionNotEmptyError, position unless @grid[row][col].nil?

    @grid[row][col] = piece
    piece.position = position
    add_active_piece(piece) unless @active_pieces.value?(piece)
  end

  def remove_piece(position)
    raise InvalidPositionError, position unless valid_position?(position)

    piece = piece_at(position)
    remove_active_piece(piece)
    @grid[position[0]][position[1]] = nil
  end

  def move_piece(piece, destination)
    raise NoPieceError, piece unless piece.is_a?(Piece)
    raise InvalidPositionError, destination unless valid_position?(destination)
    raise PositionNotEmptyError, destination unless valid_move?(piece, destination)

    destination_piece = @grid[destination[0]][destination[1]]

    # Update the grid
    update_grid_on_move(piece, destination)

    # Remove the destination piece from active_pieces if it exists
    remove_active_piece(destination_piece) if destination_piece

    # Update the moving piece's position
    piece.position = destination
  end

  def valid_position?(position)
    row, col = position
    row.between?(0, 7) && col.between?(0, 7)
  end

  def piece_at(position)
    return nil unless valid_position?(position)

    row, col = position
    @grid[row][col]
  end

  def position_of(piece)
    raise NoPieceError, piece unless piece.is_a?(Piece)

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
    piece.type == 'queen' || piece.type == 'king' ? new_key : "#{new_key}#{next_piece_count(new_key)}"
  end

  def next_piece_count(new_key)
    count = 1
    count += 1 while @active_pieces.key?(new_key + count.to_s)
    count
  end

  def add_active_piece(piece)
    @active_pieces[piece_key(piece)] = piece
  end

  def remove_active_piece(piece)
    @active_pieces.delete_if { |_, v| v == piece }
  end

  def valid_move?(piece, destination)
    return false unless valid_position?(destination)

    destination_piece = @grid[destination[0]][destination[1]]
    !(destination_piece && destination_piece.color == piece.color)
  end

  def update_grid_on_move(piece, destination)
    @grid[piece.position[0]][piece.position[1]] = nil
    @grid[destination[0]][destination[1]] = piece
  end
end
