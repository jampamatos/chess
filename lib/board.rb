# frozen_string_literal: true

require_relative 'dependencies'

class Board
  include ActivePiecesManager
  include BoardSetup
  include BoardUtility
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
    BoardSetup.generate_pieces(self, :white)
    BoardSetup.generate_pieces(self, :black)
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

  def find_rook_at(position, color)
    piece = piece_at(position)
    piece if piece&.type == :rook && piece&.color == color
  end

  def king_move_will_put_it_in_check?(king, destination)
    old_position = king.position
    captured_piece = piece_at(destination)

    # Temporarily update the board state
    update_board_state(king, destination)

    # Check if the king is in check
    in_check = king_in_check?(king.color)

    # Revert the board state
    update_board_state(king, old_position)
    place_piece(captured_piece, destination) if captured_piece
    in_check
  end

  def king_in_check?(color)
    opponent_pieces = pieces_of_color(opposing_color(color)).reject { |piece| piece.type == :king }
    king_position = find_king(color).position

    opponent_pieces.any? { |piece| piece.possible_moves(self).include?(king_position) }
  end

  private

  def new_grid
    Array.new(8) { Array.new(8, nil) }
  end

  def update_board_state(piece, new_position)
    change_piece_at(piece.position, nil)
    change_piece_at(new_position, piece)
    piece.position = new_position
  end

  def add_piece_to_board(piece, position)
    raise InvalidPositionError, position unless valid_position?(position)
    raise PositionNotEmptyError, position unless piece_at(position).nil?

    change_piece_at(position, piece)
    piece.position = position
  end

  def change_piece_at(position, piece)
    @grid[position[0]][position[1]] = piece
  end
end
