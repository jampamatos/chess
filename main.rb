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

black_pawn2 = Pawn.new('black')
board.active_pieces['black_pawn2'] = black_pawn2
board.set_piece(black_pawn2, [2, 6])

black_rook= Rook.new('black')
board.active_pieces['black_rook'] = black_rook
board.set_piece(black_rook, [2, 5])

board.draw_board
p white_king.possible_moves(board)
#C6