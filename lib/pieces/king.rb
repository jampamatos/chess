# frozen_string_literal: true

require_relative '../piece'
require 'colorize'

class King < Piece
  attr_accessor :under_attack
  def initialize(color)
    symbol = color == 'white' ? '♔'.colorize(color) : '♚'.colorize(color)
    super(color, :king, symbol)
    @under_attack = []
    @check = false
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
          # check if the destination square is not under attack by an enemy piece
          if dest_piece.nil? && board.square_under_attack?([dest_row, dest_col], @color, self)
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

  def in_check?
    @check
  end

  def check_king
    @check = true
  end

  def uncheck_king
    @check = false
  end
end