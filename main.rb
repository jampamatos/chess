# frozen_string_literal: true

require_relative 'lib/dependencies'

board = Board.new

white_king = King.new(:white)
white_rook = Rook.new(:white)
white_pawn = Pawn.new(:white)
white_queen = Queen.new(:white)
black_pawn = Pawn.new(:black)

board.place_piece(white_king, [7, 4])
board.place_piece(white_rook, [7, 7])
board.place_piece(white_pawn, [6, 4])
board.place_piece(white_queen, [7, 1])
board.place_piece(black_pawn, [3, 3])

gm = GameManager.new(board)

gm.draw_board

p white_pawn.possible_moves(board)
puts gm.move_piece([6, 4], [4, 4])
gm.draw_board

puts gm.move_piece([3, 3], [4, 4])
gm.draw_board

puts gm.move_piece([7, 1], [4, 4])
gm.draw_board

puts gm.move_piece([7, 4], [7, 6])
gm.draw_board