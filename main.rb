# frozen_string_literal: true

require_relative 'lib/gamemanager'

# gm = GameManager.new
# gm.draw_board
# gm.set_piece(gm.white_pawn1, [2, 0])
# gm.draw_board

board = Board.new
white_knight = Knight.new('white')
black_knight = Knight.new('black')

board.set_piece(white_knight, [3, 3])
board.set_piece(black_knight, [5, 2])

board.draw_board
