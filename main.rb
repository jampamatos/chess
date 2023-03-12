# frozen_string_literal: true

require_relative 'lib/gamemanager'

gm = GameManager.new
new_board = Board.new
gm.board = new_board
board = new_board

white_king = King.new('white')
board.active_pieces['white_king'] = white_king
board.set_piece(white_king, [4, 4])

black_pawn = Pawn.new('black')
board.active_pieces['black_pawn'] = black_pawn
board.set_piece(black_pawn, [2, 2])

p board.active_pieces

board.draw_board

p white_king.possible_moves(board)

white_king.move([3, 5], board)
p white_king.under_attack
board.draw_board

#C6