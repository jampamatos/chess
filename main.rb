# frozen_string_literal: true

require_relative 'lib/dependencies'

board = Board.new
white_king = King.new(:white)
white_rook1 = Rook.new(:white)
white_rook2 = Rook.new(:white)
black_rook1 = Rook.new(:black)
black_rook2 = Rook.new(:black)

board.add_piece(white_king, [7, 4])
board.add_piece(white_rook1, [7, 0])
board.add_piece(white_rook2, [7, 7])
board.add_piece(black_rook1, [0, 1])
board.add_piece(black_rook2, [0, 6])
board.draw_board
p white_king.possible_moves(board)
