# frozen_string_literal: true

require_relative 'dependencies'

class GameManager
  include GameStateChecker
  include MoveHandler
  attr_reader :board, :board_render, :moves, :turn

  def initialize(board = Board.new, board_render = BoardRender.new(board), moves = [], turn = :white)
    @board = board
    @board_render = board_render
    @moves = moves
    @turn = turn

    board.set_up_board if board.grid.flatten.compact.empty?
  end

  def draw_board
    @board_render.draw_board
  end

  def move_piece(start_position, end_position)
    moving_piece, destination_piece = find_pieces(start_position, end_position)

    validate_move(moving_piece, end_position)

    move = create_move(start_position, end_position, moving_piece, destination_piece)
    perform_move(moving_piece, destination_piece, end_position, move)

    @moves << move
    move
  end

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
    raise InvalidMoveError.new(piece, destination) unless piece.possible_moves(@board).include?(destination)
  end

  def find_pieces(start_position, end_position)
    moving_piece = @board.piece_at(start_position)
    destination_piece = if @board.piece_at(end_position)
                          @board.piece_at(end_position)
                        elsif @board.en_passant_target == end_position
                          @board.piece_at([start_position[0] + (moving_piece.color == :white ? -1 : 1), end_position[1]])
                        end
    [moving_piece, destination_piece]
  end

  def create_move(start_position, end_position, moving_piece, destination_piece)
    Move.new(start_position, end_position, moving_piece, destination_piece, @board.en_passant_target)
  end

  def perform_move(moving_piece, destination_piece, end_position, move)
    capture_piece(destination_piece, move) if capture_move?(moving_piece, destination_piece)
    handle_castling(moving_piece, end_position) if moving_piece.type == :king
    handle_en_passant(moving_piece, end_position) if moving_piece.type == :pawn
    move_piece_to_new_position(moving_piece, end_position)
    if moving_piece.type == :pawn && moving_piece.can_promote?
      promotion_piece_type = get_promotion_piece_type
      handle_promotion(moving_piece, end_position, promotion_piece_type, move)
    end
  end

  def move_piece_to_new_position(moving_piece, end_position)
    @board.update_grid_on_move(moving_piece, end_position)
    moving_piece.position = end_position
    moving_piece.mark_as_moved
  end

  def capture_move?(moving_piece, destination_piece)
    destination_piece && destination_piece.color != moving_piece.color
  end

  def capture_piece(captured_piece, move)
    move.captured_piece = captured_piece
    @board.take_piece(captured_piece.position)
  end
end
