# frozen_string_literal: true

require_relative 'lib/dependencies'

board = Board.new
white_king = King.new(:white)
black_queen = Queen.new(:black)

board.add_piece(white_king, [0, 0])
board.add_piece(black_queen, [6, 5])
board.draw_board