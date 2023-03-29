# frozen_string_literal: true

require_relative 'lib/dependencies'

board = Board.new
white_king = King.new(:white)
white_rook = Rook.new(:white)

board.add_piece(white_king, [7, 4])
board.add_piece(white_rook, [7, 7])

board.draw_board

board.move_piece(white_king, [7, 6])
board.draw_board