# frozen_string_literal: true

require_relative 'lib/dependencies'

board = Board.new
white_pawn = Pawn.new(:white)
black_pawn = Pawn.new(:black)

board.add_piece(white_pawn, [1, 0])
board.add_piece(black_pawn, [6, 0])
board.draw_board
p board.active_pieces

board.move_piece(white_pawn, [0, 0])
board.draw_board
p board.active_pieces

board.move_piece(black_pawn, [7, 0])
board.draw_board
p board.active_pieces
new_white_queen = board.piece_at([0, 0])
new_black_queen = board.piece_at([7, 0])

p new_white_queen
p new_black_queen

p new_white_queen.possible_moves(board)
p new_black_queen.possible_moves(board)