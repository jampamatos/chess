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
    if @board.piece_at(end_position)
      destination_piece = @board.piece_at(end_position)
    elsif @board.en_passant_target == end_position
      destination_piece = @board.piece_at([start_position[0] + (moving_piece.color == :white ? -1 : 1), end_position[1]])
    else
      destination_piece = nil
    end

    # Validate moves
    validate_move(moving_piece, end_position)

    # Store information about the move
    move = Move.new(start_position, end_position, moving_piece, destination_piece, @board.en_passant_target)
  
    # Check if the move is a capture
    capture_piece(destination_piece, move) if capture_move?(moving_piece, destination_piece)
    # Check if the move is a castling
    handle_castling(moving_piece, end_position) if moving_piece.type == :king
    # Check if the move is an en passant
    handle_en_passant(moving_piece, end_position) if moving_piece.type == :pawn
    # Move the piece
    @board.update_grid_on_move(moving_piece, end_position)
    moving_piece.position = end_position
    moving_piece.mark_as_moved
    # Check if the move is a promotion
    if moving_piece.type == :pawn && (end_position[0].zero? || end_position[0] == 7)
      handle_promotion(moving_piece, end_position)
    end
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
    rook.position = rook_destination
    rook.mark_as_moved
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

  def handle_en_passant(piece, destination)
    # if the piece is a pawn and is moving to @en_passant_target, remove the piece 'behind' it
    en_passant_capture(piece, destination)

    # set en passant target to the square 'behind' it if the piece is a pawn and is moving two squares
    update_en_passant_target(piece, destination)
  end

  def en_passant_capture(piece, destination)
    if piece.type == :pawn && destination == @board.en_passant_target
      @board.take_piece([destination[0] + (piece.color == :white ? 1 : -1), destination[1]])
    end
  end

  def update_en_passant_target(piece, destination)
    if piece.type == :pawn && (destination[0] - piece.position[0]).abs == 2
      @board.en_passant_target = [destination[0] + (piece.color == :white ? 1 : -1), destination[1]]
    else
      @board.en_passant_target = nil
    end
  end

  def handle_promotion(pawn, end_position)
    @board.take_piece(end_position)
    new_piece_type = get_promotion_piece_type

    new_piece = create_promotion_piece(new_piece_type, pawn.color)
    @board.place_promotion_piece(new_piece, end_position)
  end

  def get_promotion_piece_type
    choices = {
      'q' => :queen,
      'r' => :rook,
      'b' => :bishop,
      'k' => :knight
    }

    loop do
      puts 'Choose a piece to promote to: (Q)ueen, (R)ook, (B)ishop or (K)night.'
      STDOUT.flush
      user_input = gets.chomp.downcase

      if choices.keys.include?(user_input[0]) || choices.values.map(&:to_s).include?(user_input)
        return choices[user_input[0]] || user_input.to_sym
      else
        puts 'Invalid input. Please try again.'
      end
    end
  end

  def create_promotion_piece(type, color)
    case type
    when :queen
      Queen.new(color)
    when :rook
      Rook.new(color)
    when :bishop
      Bishop.new(color)
    when :knight
      Knight.new(color)
    end
  end
end
