# frozen_string_literal: true

require_relative 'lib/gamemanager'

# gm = GameManager.new
# gm.draw_board
# gm.set_piece(gm.white_pawn1, [2, 0])
# gm.draw_board

board = Board.new
white_rook = Rook.new('white')
black_pawn = Pawn.new('black')
board.set_piece(white_rook, [3, 3])
board.set_piece(black_pawn, [3, 6])
board.draw_board
