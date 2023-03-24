# frozen_string_literal: true

require_relative '../dependencies'

module ActivePiecesManager

  private
  
  def piece_key(piece)
    new_key = "#{piece.color.downcase}_#{piece.type.downcase}"
    piece.type == :queen || piece.type == :king ? new_key : "#{new_key}#{next_piece_count(new_key)}"
  end

  def promotion_piece_key(piece)
    color_type_prefix = "promoted_#{piece.color.downcase}_#{piece.type.downcase}"
    count = next_piece_count(color_type_prefix)
    "#{color_type_prefix}#{count}"
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
end