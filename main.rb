# frozen_string_literal: true

require_relative 'lib/gamemanager'

board = Board.new
white_pawn = Pawn.new('white')
black_pawn = Pawn.new('black')

board.set_piece(white_pawn, [3, 4])
puts "White Pawn position: #{white_pawn.position}"
board.set_piece(black_pawn, [1, 3])
puts "Black Pawn position: #{black_pawn.position}"
board.draw_board
puts "En passant = #{board.en_passant}"
black_pawn.move([3, 3], board)
puts "En passant = #{board.en_passant}"
white_pawn.move([2, 3], board)
board.draw_board
puts "En passant = #{board.en_passant}"
# 
# board.draw_board
# p "En passant = #{board.en_passant}"

# D7 = 1, 3
# D5 = 3, 3
