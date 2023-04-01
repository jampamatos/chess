# frozen_string_literal: true

require_relative 'dependencies'

class GameManager
  attr_reader :board, :board_render, :moves

  def initialize(board = Board.new, board_render = BoardRender.new(board))
    @board = board
    @board_render = board_render
    @moves = []

    board.set_up_board if board.grid.flatten.compact.empty?
  end

  def draw_board
    @board_render.draw_board
  end

  def move_piece(start_position, end_position)
    moving_piece = @board.piece_at(start_position)
    destination_piece = @board.piece_at(end_position)

    # Validate moves
    validate_move(moving_piece, end_position)

    # Store information about the move
    move = Move.new(start_position, end_position, moving_piece, destination_piece)

    # Check if the move is a capture
    capture_piece(destination_piece, move) if capture_move?(moving_piece, destination_piece)
    # Check if the move is a castling
    handle_castling(moving_piece, end_position) if moving_piece.type == :king
    # Check if the move is an en passant
    # Check if the move is a promotion

    # Move the piece
    @board.update_grid_on_move(moving_piece, end_position)
    moving_piece.position = end_position
    moving_piece.mark_as_moved
    @moves << move
    move
  end

  def is_check?; end

  def is_checkmate?; end

  def is_draw?; end

  def valid_move?(piece, destination)
    return false unless @board.valid_position?(destination)

    destination_piece = @board.piece_at(destination)
    !(destination_piece && destination_piece.color == piece.color)
  end

  def next_turn; end

  private

  def validate_move(piece, destination)
    raise NoPieceError, piece unless piece.is_a?(Piece)
    raise InvalidPositionError, destination unless @board.valid_position?(destination)
    raise PositionNotEmptyError, destination unless valid_move?(piece, destination)
    # raise MoveWillPutKingIntoCheckError.new(piece, destination) if piece.type == :king && king_move_will_put_it_in_check?(piece, destination)
    raise InvalidMoveError.new(piece, destination) unless piece.possible_moves(@board).include?(destination)
  end

  def capture_move?(moving_piece, destination_piece)
    destination_piece && destination_piece.color != moving_piece.color
  end

  def capture_piece(captured_piece, move)
    move.captured_piece = captured_piece
    @board.take_piece(captured_piece.position)
  end

  def handle_castling(king, destination)
    return unless castling_move?(king, destination)

    rook_position, rook_destination = calculate_rook_positions(king, destination)
    rook = @board.piece_at(rook_position)
    return unless rook.type == :rook && rook.moved == false

    @board.update_grid_on_move(rook, rook_destination)
    #@board.update_grid_on_move(king, destination)
    rook.position = rook_destination
    #king.position = destination
  end

  def castling_move?(piece, destination)
    piece.type == :king && (destination[1] - piece.position[1]).abs == 2
  end

  def calculate_rook_positions(piece, destination)
    rook_file = destination[1] > piece.position[1] ? 7 : 0
    rook_position = [piece.position[0], rook_file]
    rook_destination_file = destination[1] > piece.position[1] ? 5 : 3
    rook_destination = [piece.position[0], rook_destination_file]
    [rook_position, rook_destination]
  end
end
