# frozen_string_literal: true

require_relative '../dependencies'

module MoveHandler
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

  def handle_promotion(pawn, end_position, promotion_piece_type, move)
    @board.take_piece(end_position)
    new_piece = create_promotion_piece(promotion_piece_type, pawn.color)
    @board.place_promotion_piece(new_piece, end_position)
    new_piece.mark_as_moved
    move.promotion_piece = new_piece
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