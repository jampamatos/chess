# frozen_string_literal: true

require_relative 'dependencies'

BG_COLOR_EVEN = :light_black
BG_COLOR_ODD = :black

PIECES_RANK = { white: 7, black: 0 }.freeze
PAWNS_RANK = { white: 6, black: 1 }.freeze

class Board
  attr_reader :grid, :active_pieces, :en_passant_target

  def initialize(grid = new_grid, active_pieces = {}, en_passant_target: nil)
    @grid = grid
    @active_pieces = active_pieces
    @en_passant_target = en_passant_target
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
    puts "Moving #{piece} to #{destination}"
    puts "Now, #{piece}'s possible moves are: #{piece.possible_moves(self)}"
    validate_move(piece, destination)

    move_piece!(piece, destination)
  end

  def move_piece!(piece, destination)
    destination_piece = piece_at(destination)

    handle_en_passant(piece, destination)
    handle_castling(piece, destination)

    # Update the grid
    update_grid_on_move(piece, destination)

    # Remove the destination piece from active_pieces if it exists
    remove_active_piece(destination_piece) if destination_piece

    # Update the moving piece's position
    update_moving_piece(piece, destination)
    handle_promotion(piece, destination)
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

  def find_rook_at(position, color)
    piece_at(position) if piece_at(position)&.type == :rook && piece_at(position)&.color == color
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
    add_piece(temp_piece, position)

    # Check if the temporary piece is under attack
    under_attack = false
    pieces_of_color(opposing_color(color)).each do |piece|
      under_attack = true if piece.possible_moves(self).include?(position)
    end

    # Remove the temporary piece
    remove_piece(position)

    under_attack
  end

  def opposing_color(color)
    color == :white ? :black : :white
  end

  private

  def new_grid
    Array.new(8) { Array.new(8, nil) }
  end

  def piece_key(piece)
    new_key = "#{piece.color.downcase}_#{piece.type.downcase}"
    piece.type == :queen || piece.type == :king ? new_key : "#{new_key}#{next_piece_count(new_key)}"
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

  def validate_move(piece, destination)
    raise NoPieceError, piece unless piece.is_a?(Piece)
    raise InvalidPositionError, destination unless valid_position?(destination)
    raise PositionNotEmptyError, destination unless valid_move?(piece, destination)
    raise InvalidMoveError.new(piece, destination) unless piece.possible_moves(self).include?(destination)
  end

  def handle_en_passant(piece, destination)
    # if the piece is a pawn and is moving to @en_passant_target, remove the piece 'behind' it
    en_passant_capture(piece, destination)

    # set en passant target to the square 'behind' it if the piece is a pawn and is moving two squares
    update_en_passant_target(piece, destination)
  end

  def handle_castling(piece, destination)
    return unless castling_possible?(piece, destination)

    direction = castling_direction(destination, piece.position[1])
    rook_start_col = direction == -1 ? 0 : 7
    rook = piece_at([piece.position[0], rook_start_col])

    perform_castling(piece, destination, rook, direction)
  end

  def handle_promotion(piece, destination)
    return unless piece.type == :pawn && piece.can_promote?

    promote_pawn(piece, destination)
  end

  def update_en_passant_target(piece, destination)
    if piece.type == :pawn && (destination[0] - piece.position[0]).abs == 2
      @en_passant_target = [destination[0] + (piece.color == :white ? 1 : -1), destination[1]]
    else
      @en_passant_target = nil
    end
  end

  def en_passant_capture(piece, destination)
    if piece.type == :pawn && destination == @en_passant_target
      remove_piece([destination[0] + (piece.color == :white ? 1 : -1), destination[1]])
    end
  end

  def update_moving_piece(piece, destination)
    piece.mark_as_moved
    piece.position = destination
  end

  def castling_possible?(piece, destination)
    piece.type == :king && piece.special_moves(self).include?(destination)
  end

  def castling_direction(destination, position)
    destination[1] < position ? -1 : 1
  end

  def perform_castling(king, destination, rook, direction)
    update_grid_on_move(king, destination)
    update_grid_on_move(rook, [rook.position[0], king.position[1] + direction])
    king.mark_as_moved
    rook.mark_as_moved
  end

  def promote_pawn(pawn, destination)
    piece_type = request_piece_type
    remove_piece(pawn.position)
    new_piece = create_piece(piece_type, pawn.color)
    change_piece_at(destination, new_piece)
    add_promoted_active_piece(new_piece)
    new_piece.mark_as_moved.position = destination
  end

  def request_piece_type
    loop do
      puts 'Select a piece to promote to: (Q)ueen, (R)ook, (B)ishop, (K)night'
      $stdout.flush
      input = gets.chomp.downcase
      piece_type = piece_type_from_input(input)
      return piece_type if piece_type
    end
  end

  def piece_type_from_input(input)
    piece_types = { 'q' => :queen, 'r' => :rook, 'b' => :bishop, 'k' => :knight }
    piece_types[input] || (puts 'Invalid input. Please enter Q, R, B, or K.' && $stdout.flush)
  end

  def create_piece(piece_type, color)
    Object.const_get(piece_type.capitalize).new(color)
  end

  def promoted_piece_key(piece)
    "promoted_#{piece.color.downcase}_#{piece.type.downcase}#{next_piece_count("promoted_#{piece.color.downcase}_#{piece.type.downcase}")}"
  end

  def add_promoted_active_piece(piece)
    @active_pieces[promoted_piece_key(piece)] = piece
  end
end
