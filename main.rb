# frozen_string_literal: true

require_relative 'lib/dependencies'

board = Board.new
white_king = King.new(:white)
black_pawn = Pawn.new(:black)

board.add_piece(white_king, [4, 4])
board.add_piece(black_pawn, [2, 3])

board.draw_board
p white_king.possible_moves(board)