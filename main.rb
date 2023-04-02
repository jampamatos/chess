# frozen_string_literal: true

require_relative 'lib/dependencies'

board = Board.new

white_pawn = Pawn.new(:white)
black_pawn = Pawn.new(:black)

board.place_piece(white_pawn, [3, 2])
board.place_piece(black_pawn, [1, 1])

gm = GameManager.new(board)

gm.draw_board

gm.move_piece([1, 1], [3, 1])
gm.draw_board
p gm.board.en_passant_target
p white_pawn.possible_moves(gm.board)
move = gm.move_piece([3, 2], [2, 1])
gm.draw_board
puts move