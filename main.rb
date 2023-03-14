# frozen_string_literal: true

require_relative 'lib/gamemanager'

board = Board.new
gm = GameManager.new(board, nil, 'black')

black_king = King.new('black')
white_queen = Queen.new('white')

board.set_piece(black_king, [0, 0])
board.active_pieces['black_king'] = black_king
board.set_piece(white_queen, [1, 5])
board.active_pieces['white_queen'] = white_queen

board.draw_board

white_queen.move([1, 2], board)
board.draw_board

gm.play_turn
