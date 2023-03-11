# frozen_string_literal: true

require_relative 'lib/gamemanager'

gm = GameManager.new
new_board = Board.new
gm.board = new_board
board = new_board
white_pawn = Pawn.new('white')
black_pawn = Pawn.new('black')

board.set_piece(white_pawn, [2, 4])
board.set_piece(black_pawn, [5, 4])
board.draw_board


puts black_pawn.move([6, 4], board, gm)
puts white_pawn.move([1, 4], board, gm)
board.draw_board

puts black_pawn.move([7, 4], board, gm)
puts white_pawn.move([0, 4], board, gm)
board.draw_board
p board.grid[7][4].possible_moves(board)
p board.grid[0][4].possible_moves(board)
board.draw_board