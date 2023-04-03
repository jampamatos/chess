# frozen_string_literal: true

require_relative 'lib/dependencies'

board = Board.new
white_king = King.new(:white)
friendly_color_piece = Piece.new(:white, :piece, 'P')
opposing_color_piece = Piece.new(:black, :piece, 'P')

board.place_piece(white_king, [4, 4])
board.place_piece(friendly_color_piece, [4, 3])
board.place_piece(opposing_color_piece, [5, 4])

gm = GameManager.new(board)
gm.draw_board
p white_king.possible_moves(gm.board)
puts gm.move_piece([4, 4], [5, 3])
gm.draw_board
