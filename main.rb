# frozen_string_literal: true

require_relative 'lib/dependencies'

board = Board.new
board.place_piece(Pawn.new(:white), [6, 1])
board.place_piece(Pawn.new(:black), [5, 1])
board.place_piece(Rook.new(:white), [6, 0])
board.place_piece(Rook.new(:black), [5, 2])
gm = GameManager.new(board)

p gm.board.active_pieces

p gm.board.square_under_attack?([6, 1], :white)
p gm.board.square_under_attack?([5, 1], :black)
p gm.board.square_under_attack?([5, 2], :black)
p gm.board.square_under_attack?([6, 0], :white)

p gm.board.active_pieces

gm.draw_board
