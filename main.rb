# frozen_string_literal: true

require_relative 'lib/dependencies'

board = Board.new
white_pawn = Pawn.new(:white)
black_pawn = Pawn.new(:black)

board.place_piece(white_pawn, [6, 5])
white_pawn.mark_as_moved
board.place_piece(black_pawn, [4, 4])

gm = GameManager.new(board)
gm.draw_board

gm.move_piece([4, 4], [6, 4])
gm.draw_board

gm.move_piece([6, 5], [5, 4])
gm.draw_board
