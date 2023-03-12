# frozen_string_literal: true

require_relative 'piece'
require 'colorize'

class King < Piece
  attr_accessor :under_attack
  def initialize(color)
    symbol = color == 'white' ? '♔'.colorize(color) : '♚'.colorize(color)
    super(color, :king, symbol)
    @under_attack = []
  end

  def to_unicode
    @color == 'white' ? " \u2654 " : " \u265A "
  end

  def possible_moves(board, position = @position)
    moves = []

    row, col = position
    (-1..1).each do |i|
      (-1..1).each do |j|
        next if i == 0 && j == 0 # the king can't stay in the same position

        dest_row, dest_col = row + i, col + j
        next unless valid_position?([dest_row, dest_col])

        dest_piece = board[[dest_row, dest_col]]

        if dest_piece.nil? || dest_piece.color != @color
          puts "Position before square_under_attack call: #{dest_row}, #{dest_col}"
          # check if the destination square is not under attack by an enemy piece
          if board.square_under_attack?([dest_row, dest_col], @color, self)
            @under_attack << [dest_row, dest_col]
            next
          else
            moves << [dest_row, dest_col]
          end
        end
      end
    end

    moves
  end

  def move(destination, board, _game_manager = nil)
    if @under_attack.include? destination
      @under_attack = []
      raise InvalidMoveError, 'Invalid move. Square under attack.'
    end

    @under_attack = []
    super
  end
end