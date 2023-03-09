# frozen_string_literal: true

require_relative 'lib/gamemanager'

board = Board.new
white_pawn = Pawn.new('white')
black_pawn = Pawn.new('black')

board.set_piece(white_pawn, [4, 4])
board.set_piece(black_pawn, [4, 1])
puts "White pawn moves: #{white_pawn.possible_moves(board)}"
puts "Black pawn moves: #{black_pawn.possible_moves(board)}"

board.draw_board

puts '------------------'

gm = GameManager.new
gm.board.draw_board