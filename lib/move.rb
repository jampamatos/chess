# frozen_string_literal: true

require_relative 'dependencies'

class Move
  attr_accessor :start_position, :end_position, :piece, :captured_piece, :en_passant_target

  def initialize(start_position, end_position, piece, captured_piece = nil, en_passant_target = nil)
    @start_position = start_position
    @end_position = end_position
    @piece = piece
    @captured_piece = captured_piece
    @en_passant_target = en_passant_target
  end

  def to_s
    return notation_for_pawn if @piece.type == :pawn
    return notation_for_castling if castling?
    return notation_general if @piece.type != :pawn
  end

  def reset
    @start_position = nil
    @end_position = nil
    @piece = nil
    @captured_piece = nil
  end

  def capture?
    @captured_piece || en_passant?
  end

  def castling?
    @piece.type == :king && (@start_position[1] - @end_position[1]).abs == 2
  end

  def en_passant?
    return false unless @piece.type == :pawn && @end_position == @en_passant_target

    expected_en_passant_target_row = @start_position[0] + (@piece.color == :white ? -1 : 1)
    expected_en_passant_target = [expected_en_passant_target_row, @end_position[1]]

    @end_position == expected_en_passant_target
  end

  def promotion?; end

  def check?; end

  def checkmate?; end

  private

  def convert_coordinates(position)
    row, col = position
    row = 8 - row
    col = ('a'..'h').to_a[col]
    "#{col}#{row}"
  end

  def letter_for_piece_notation(piece)
    case piece.type
    when :rook then 'R'
    when :knight then 'N'
    when :bishop then 'B'
    when :queen then 'Q'
    when :king then 'K'
    end
  end

  def notation_for_pawn
    notation = ''
    notation += convert_coordinates(@start_position)[0] if capture?
    notation += 'x' if capture?
    notation += convert_coordinates(@end_position)
    notation += ' e.p.' if en_passant?
    notation += '+' if check?
    notation += '#' if checkmate?
    # notation += '=' + letter_for_piece_notation(new_piece) if promotion?
    notation
  end

  def notation_for_castling
    notation = ''
    notation += 'O-O' if @end_position[1] == 6
    notation += 'O-O-O' if @end_position[1] == 2
    notation
  end

  def notation_general
    notation = letter_for_piece_notation(@piece)
    notation += 'x' if capture?
    notation += convert_coordinates(@end_position)
    notation += '+' if check?
    notation += '#' if checkmate?
    notation
  end
end
