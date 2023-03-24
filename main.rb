# frozen_string_literal: true

require_relative 'lib/dependencies'

board = Board.new
white_rook = Rook.new('white')

board.add_piece(white_rook, [0, 0])
board.draw_board
