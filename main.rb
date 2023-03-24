# frozen_string_literal: true

require_relative 'lib/dependencies'

board = Board.new
board.set_up_board
board.draw_board
p board.active_pieces
