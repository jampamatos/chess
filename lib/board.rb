# frozen_string_literal: true

require_relative 'dependencies'

class Board
  BG_COLOR_EVEN = :light_black
  BG_COLOR_ODD = :black

  PIECES_RANK = { white: 7, black: 0 }.freeze
  PAWNS_RANK = { white: 6, black: 1 }.freeze

  attr_reader :grid, :active_pieces
  attr_accessor :en_passant_target

  def initialize(grid = new_grid, active_pieces = {}, en_passant_target: nil)
    @grid = grid
    @active_pieces = active_pieces
    @en_passant_target = en_passant_target
  end

  def place_piece(piece, position)
    add_piece_to_board(piece, position)
    add_active_piece(piece) unless @active_pieces.value?(piece)
  end

  def place_promotion_piece(piece, position)
    add_piece_to_board(piece, position)
    add_promotion_active_piece(piece)
  end

  def take_piece(position)
    raise InvalidPositionError, position unless valid_position?(position)

    piece = piece_at(position)
    remove_active_piece(piece)
    change_piece_at(position, nil)
  end

  def update_grid_on_move(piece, destination)
    @grid[piece.position[0]][piece.position[1]] = nil
    @grid[destination[0]][destination[1]] = piece
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

  def friendly_pieces_of_type(type, color)
    pieces_of_color(color).select { |piece| piece.type == type }
  end

  def find_king(color)
    friendly_pieces_of_type(:king, color).first
  end

  def set_up_board
    generate_pieces(:white)
    generate_pieces(:black)
  end

  def pieces_rank(color)
    PIECES_RANK[color]
  end

  def pawns_rank(color)
    PAWNS_RANK[color]
  end

  def square_under_attack?(position, color)
    raise InvalidPositionError, position unless valid_position?(position)

    # Create a temporary piece at the given position
    temp_piece = Piece.new(color, :temp, 'T')
    place_piece(temp_piece, position) unless piece_at(position)

    # Check if the temporary piece is under attack
    under_attack = false
    pieces_of_color(opposing_color(color)).each do |piece|
      under_attack = true if piece.possible_moves(self).include?(position)
    end

    # Remove the temporary piece
    take_piece(position) if piece_at(position) == temp_piece

    under_attack
  end

  def opposing_color(color)
    color == :white ? :black : :white
  end

  def find_rook_at(position, color)
    piece = piece_at(position)
    piece if piece&.type == :rook && piece&.color == color
  end

  def king_move_will_put_it_in_check?(king, destination)
    # Temporarily update the board state
    old_position = king.position
    captured_piece = piece_at(destination)
    # manually remove the piece from the old position, set it to the new position and set the piece's position to the new position
    change_piece_at(old_position, nil)
    change_piece_at(destination, king)
    king.position = destination

    # Check if the king is in check
    in_check = king_in_check?(king.color)

    # Revert the board state
    change_piece_at(destination, nil)
    change_piece_at(old_position, king)
    king.position = old_position
    place_piece(captured_piece, destination) if captured_piece
    in_check
  end

  def king_in_check?(color)
    pieces_of_color(opposing_color(color)).reject { |piece| piece.type == :king }.any? { |piece| piece.possible_moves(self).include?(find_king(color).position) }
  end

  private

  def new_grid
    Array.new(8) { Array.new(8, nil) }
  end

  def add_piece_to_board(piece, position)
    raise InvalidPositionError, position unless valid_position?(position)
    raise PositionNotEmptyError, position unless piece_at(position).nil?

    change_piece_at(position, piece)
    piece.position = position
  end

  def piece_key(piece)
    new_key = "#{piece.color.downcase}_#{piece.type.downcase}"
    piece.type == :queen || piece.type == :king ? new_key : "#{new_key}#{next_piece_count(new_key)}"
  end

  def promotion_piece_key(piece)
    "promoted_#{piece.color.downcase}_#{piece.type.downcase}#{next_piece_count("promoted_#{piece.color.downcase}_#{piece.type.downcase}")}"
  end

  def next_piece_count(new_key)
    count = 1
    count += 1 while @active_pieces.key?(new_key + count.to_s)
    count
  end

  def add_active_piece(piece)
    @active_pieces[piece_key(piece)] = piece
  end

  def add_promotion_active_piece(piece)
    @active_pieces[promotion_piece_key(piece)] = piece
  end

  def remove_active_piece(piece)
    @active_pieces.delete_if { |_, v| v == piece }
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
      place_piece(pawn, position)
    end
  end

  def generate_rooks(color)
    [0, 7].each do |col|
      position = [PIECES_RANK[color], col]
      rook = Rook.new(color)
      place_piece(rook, position)
    end
  end

  def generate_knights(color)
    [1, 6].each do |col|
      position = [PIECES_RANK[color], col]
      knight = Knight.new(color)
      place_piece(knight, position)
    end
  end

  def generate_bishops(color)
    [2, 5].each do |col|
      position = [PIECES_RANK[color], col]
      bishop = Bishop.new(color)
      place_piece(bishop, position)
    end
  end

  def generate_queen(color)
    position = [PIECES_RANK[color], 3]
    place_piece(Queen.new(color), position)
  end

  def generate_king(color)
    position = [PIECES_RANK[color], 4]
    place_piece(King.new(color), position)
  end

  # def promote_pawn(pawn, destination)
  #   piece_type = request_piece_type
  #   take_piece(pawn.position)
  #   new_piece = create_piece(piece_type, pawn.color)
  #   change_piece_at(destination, new_piece)
  #   add_promoted_active_piece(new_piece)
  #   new_piece.mark_as_moved.position = destination
  # end

  # def request_piece_type
  #   loop do
  #     puts 'Select a piece to promote to: (Q)ueen, (R)ook, (B)ishop, (K)night'
  #     $stdout.flush
  #     input = gets.chomp.downcase
  #     piece_type = piece_type_from_input(input)
  #     return piece_type if piece_type
  #   end
  # end

  # def piece_type_from_input(input)
  #   piece_types = { 'q' => :queen, 'r' => :rook, 'b' => :bishop, 'k' => :knight }
  #   piece_types[input] || (puts 'Invalid input. Please enter Q, R, B, or K.' && $stdout.flush)
  # end

  # def create_piece(piece_type, color)
  #   Object.const_get(piece_type.capitalize).new(color)
  # end

  # def promoted_piece_key(piece)
  #   "promoted_#{piece.color.downcase}_#{piece.type.downcase}#{next_piece_count("promoted_#{piece.color.downcase}_#{piece.type.downcase}")}"
  # end

  # def add_promoted_active_piece(piece)
  #   @active_pieces[promoted_piece_key(piece)] = piece
  # end
end
