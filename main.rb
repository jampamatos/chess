# frozen_string_literal: true

require_relative 'lib/dependencies'

board = Board.new
white_queen = Queen.new(:white)
friendly_color_piece = Piece.new(:white, :piece, 'P')
# opposing_color_piece = Piece.new(:black, :piece, 'P')

board.place_piece(white_queen, [4, 4])
board.place_piece(friendly_color_piece, [4, 0])
board.place_piece(friendly_color_piece, [0, 4])

gm = GameManager.new(board)
gm.draw_board
p white_queen.possible_moves(gm.board)

