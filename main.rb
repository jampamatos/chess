# frozen_string_literal: true

require_relative 'lib/dependencies'

board = Board.new
black_king = King.new(:black)
black_rook1 = Rook.new(:black)
black_rook2 = Rook.new(:black)

white_king = King.new(:white)

board.place_piece(white_king, [0, 7])
board.place_piece(black_king, [7, 3])
board.place_piece(black_rook1, [1, 1])
board.place_piece(black_rook2, [2, 0])

gm = GameManager.new(board)
gm.draw_board
p gm.check?
p gm.checkmate?

gm.move_piece([2, 0], [0, 0])
gm.draw_board
p gm.check?
p gm.checkmate?
puts "Swtiching turn"
gm.board.switch_turn
p gm.check?
p gm.checkmate?
