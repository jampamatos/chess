# frozen_string_literal: true

require_relative 'dependencies'

BG_COLOR_EVEN = :light_black
BG_COLOR_ODD = :black

PIECES_RANK = { 'white' => 7, 'black' => 0 }.freeze
PAWNS_RANK = { 'white' => 6, 'black' => 1 }.freeze

class Board
  attr_reader :grid, :active_pieces

  def initialize(grid = new_grid, active_pieces = {})
    @grid = grid
    @active_pieces = active_pieces
  end

  def draw_board
    puts "\n   A  B  C  D  E  F  G  H\n"
    @grid.each_with_index do |row, i|
      print "#{8 - i} "
      row.each_with_index do |piece, j|
        bg_color = (i + j).even? ? BG_COLOR_EVEN : BG_COLOR_ODD
        print piece ? " #{piece} ".colorize(background: bg_color) : '   '.colorize(background: bg_color)
      end
      print " #{8 - i}\n"
    end
    puts "\n   A  B  C  D  E  F  G  H\n"
  end

  def add_piece(piece, position)
    raise InvalidPositionError, position unless valid_position?(position)
    raise PositionNotEmptyError, position unless piece_at(position).nil?

    change_piece_at(position, piece)
    piece.position = position
    add_active_piece(piece) unless @active_pieces.value?(piece)
  end

  def remove_piece(position)
    raise InvalidPositionError, position unless valid_position?(position)

    piece = piece_at(position)
    remove_active_piece(piece)
    change_piece_at(position, nil)
  end

  def move_piece(piece, destination)
    raise NoPieceError, piece unless piece.is_a?(Piece)
    raise InvalidPositionError, destination unless valid_position?(destination)
    raise PositionNotEmptyError, destination unless valid_move?(piece, destination)

    destination_piece = piece_at(destination)

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

  def set_up_board
    generate_pieces('white')
    generate_pieces('black')
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

  def change_piece_at(position, piece)
    @grid[position[0]][position[1]] = piece
  end

  def generate_pieces(color)
    generate_pawns(color)
    generate_rooks(color)
    generate_knights(color)
    generate_bishops(color)
    generate_queen(color)
    generate_king(color)
  end

  def generate_pawns(color)
    8.times do |col|
      position = [PAWNS_RANK[color], col]
      pawn = Pawn.new(color)
      add_piece(pawn, position)
    end
  end

  def generate_rooks(color)
    [0, 7].each do |col|
      position = [PIECES_RANK[color], col]
      rook = Rook.new(color)
      add_piece(rook, position)
    end
  end

  def generate_knights(color)
    [1, 6].each do |col|
      position = [PIECES_RANK[color], col]
      knight = Knight.new(color)
      add_piece(knight, position)
    end
  end

  def generate_bishops(color)
    [2, 5].each do |col|
      position = [PIECES_RANK[color], col]
      bishop = Bishop.new(color)
      add_piece(bishop, position)
    end
  end

  def generate_queen(color)
    position = [PIECES_RANK[color], 3]
    add_piece(Queen.new(color), position)
  end

  def generate_king(color)
    position = [PIECES_RANK[color], 4]
    add_piece(King.new(color), position)
  end
end
