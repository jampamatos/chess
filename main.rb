# frozen_string_literal: true

require_relative 'lib/gamemanager'

gm = GameManager.new
board = gm.board
white_pawn = Pawn.new('white')
black_pawn = Pawn.new('black')
black_pawn2 = Pawn.new('black')

board.set_piece(white_pawn, [6, 4])
board.set_piece(black_pawn, [4, 3])
board.set_piece(black_pawn2, [6, 1])

puts "En passant = #{board.en_passant}"
puts "White Pawn position: #{white_pawn.position}"
puts "Black Pawn position: #{black_pawn.position}"
board.draw_board

white_pawn.move([4, 4], board, gm)
puts "En passant = #{board.en_passant}"
puts "White Pawn position: #{white_pawn.position}"
puts "Black Pawn position: #{black_pawn.position}"
board.draw_board

puts black_pawn.move([5, 4], board, gm)
puts "En passant = #{board.en_passant}"
puts "White Pawn position: #{white_pawn.position}"
puts "Black Pawn position: #{black_pawn.position}"
board.draw_board
puts black_pawn.move([6, 4], board, gm)
puts black_pawn.move([7, 4], board, gm)
board.draw_board
p board.grid[7][4].possible_moves(board)
puts black_pawn2.move([7, 1], board, gm)
board.draw_board
p board.grid[7][1].possible_moves(board)