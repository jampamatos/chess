# frozen_string_literal: true

require_relative 'dependencies'

class Piece
  attr_reader :moved
  attr_accessor :color, :type, :symbol, :position

  def initialize(color, type, symbol = nil, position = nil, moved: false)
    @color = color
    @type = type
    @symbol = symbol
    @position = position
    @moved = moved
  end

  def to_s
    @symbol
  end

  def same_color_as(piece)
    @color == piece.color
  end

  def possible_moves(_board)
    []
  end

  def mark_as_moved
    @moved = true
    self
  end

  private

  def move_generator(board, step, row_increment, col_increment)
    moves = []
    row, col = position

    (1..step).each do |idx|
      new_row = row + idx * row_increment
      new_col = col + idx * col_increment
      new_square = [new_row, new_col]

      break unless board.valid_position?(new_square)

      destination_piece = board.piece_at(new_square)
      break if destination_piece&.same_color_as(self)

      moves << new_square
      break if destination_piece
    end
    moves
  end
end
