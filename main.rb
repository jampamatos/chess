# frozen_string_literal: true

require_relative 'lib/dependencies'

board = Board.new

white_pawn = Pawn.new(:white)


black_pawn = Pawn.new(:black)


board.place_piece(white_pawn, [6, 0])

board.place_piece(black_pawn, [4, 1])

gm = GameManager.new(board)

gm.draw_board

p gm.board.active_pieces

p white_pawn.possible_moves(gm.board)
gm.move_piece([6, 0], [5, 0])
gm.draw_board

p white_pawn.possible_moves(gm.board)

gm.move_piece([5, 0], [4, 1])
gm.draw_board

p gm.board.active_pieces