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

  def to_s
    # generate a string to represent chess notation
    # e.g. d2, dxc3, Bc3, Qxh8, O-O, Rxg4+, etc.
    "#{piece.symbol}#{start_position}#{capture? ? 'x' : '-'}#{end_position}"
  end

  def reset
    @start_position = nil
    @end_position = nil
    @piece = nil
    @captured_piece = nil
  end

  def capture?
    @captured_piece ? true : false
  end

  def castling?; end

  def en_passant?; end

  def promotion?; end
end
