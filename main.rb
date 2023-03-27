# frozen_string_literal: true

require_relative 'lib/dependencies'

white_pawn = Pawn.new(:white)
black_pawn = Pawn.new(:black)
board = Board.new

board.add_piece(white_pawn, [6, 5])
board.add_piece(black_pawn, [4, 4])
board.draw_board
board.move_piece(white_pawn, [4, 5])
board.draw_board
p black_pawn.possible_moves(board)
board.move_piece(black_pawn, [5, 5])
board.draw_board