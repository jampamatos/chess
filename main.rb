# frozen_string_literal: true

require_relative 'lib/dependencies'

board = Board.new
white_king = King.new(:white)
black_pawn = Pawn.new(:black)

board.add_piece(white_king, [4, 4])
board.add_piece(black_pawn, [2, 3])

board.draw_board
white_king.mark_as_in_check if board.king_in_check?(:white) 
puts "King in check? #{board.king_in_check?(:white)}"
puts "King's in check = #{white_king.in_check?}"

p black_pawn.possible_moves(board)
puts "Move to D5 [3, 3] will put king in check? #{board.king_move_will_put_it_in_check?(white_king, [3, 3])}" # should be false, but returns true
puts "Move to E5 [3, 4] will put king in check? #{board.king_move_will_put_it_in_check?(white_king, [3, 4])}" # returns true
puts "Move to D4 [4, 3] will put king in check? #{board.king_move_will_put_it_in_check?(white_king, [4, 3])}" # returns false

puts "King's possible moves: #{white_king.possible_moves(board)}"
board.move_piece(white_king, [3, 3])
board.draw_board
p white_king.possible_moves(board)

board.move_piece(white_king, [3, 2])