# frozen_string_literal: true

require_relative 'lib/gamemanager'

gm = GameManager.new
gm.draw_board
gm.set_piece(gm.white_pawn1, [5, 0])
gm.draw_board