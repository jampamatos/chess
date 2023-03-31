# frozen_string_literal: true

require_relative 'dependencies'

class Move
  attr_accessor :start_position, :end_position, :piece, :captured_piece

  def initialize(start_position, end_position, piece, captured_piece = nil)
    @start_position = start_position
    @end_position = end_position
    @piece = piece
    @captured_piece = captured_piece
  end

  def reset
    @start_position = nil
    @end_position = nil
    @piece = nil
    @captured_piece = nil
  end

  def capture?; end

  def castling?; end

  def en_passant?; end

  def promotion?; end
end
