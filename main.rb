# frozen_string_literal: true

require_relative 'lib/gamemanager'

board = Board.new

white_king = King.new('white')
black_pawn = Pawn.new('black')

board.set_piece(white_king, [4, 4])
board.active_pieces['white_king'] = white_king
board.set_piece(black_pawn, [3, 4])
board.active_pieces['black_pawn'] = black_pawn
board.draw_board
p board.active_pieces
p white_king.possible_moves(board)
white_king.move([3, 4], board)
board.draw_board
p board.active_pieces
