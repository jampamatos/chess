# frozen_string_literal: true

require_relative 'lib/dependencies'

board = Board.new
white_pawn = Pawn.new(:white)
black_pawn = Pawn.new(:black)

board.place_piece(white_pawn, [1, 4])
board.place_piece(black_pawn, [6, 4])
gm = GameManager.new(board)

gm.draw_board
gm.move_piece([1, 4], [0, 4])
p gm.board.active_pieces
gm.draw_board

gm.move_piece([6, 4], [7, 4])
p gm.board.active_pieces
gm.draw_board
p gm.board.grid