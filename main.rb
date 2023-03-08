# frozen_string_literal: true

require_relative 'lib/gamemanager'

# gm = GameManager.new
# gm.draw_board
# gm.set_piece(gm.white_pawn1, [2, 0])
# gm.draw_board

board = Board.new
white_queen = Queen.new('white')
black_pawn1 = Pawn.new('black')
black_pawn2 = Pawn.new('black')
black_pawn3 = Pawn.new('black')
black_pawn4 = Pawn.new('black')
black_pawn5 = Pawn.new('black')
black_pawn6 = Pawn.new('black')

board.set_piece(white_queen, [4, 4])
board.set_piece(black_pawn1, [4, 3])
board.set_piece(black_pawn2, [3, 4])
board.set_piece(black_pawn3, [2 ,2])
board.set_piece(black_pawn4, [2, 6])
board.set_piece(black_pawn5, [6, 2])
board.set_piece(black_pawn6, [6, 6])

board.draw_board
# 21 positions