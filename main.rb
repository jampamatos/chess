# frozen_string_literal: true

require_relative 'lib/gamemanager'

# gm = GameManager.new
# gm.draw_board
# gm.set_piece(gm.white_pawn1, [2, 0])
# gm.draw_board

board = Board.new
white_bishop = Bishop.new('white')
black_pawn = Pawn.new('black')

board.set_piece(white_bishop, [4, 4])
board.set_piece(black_pawn, [5,5])

board.draw_board