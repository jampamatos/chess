# frozen_string_literal: true

require_relative 'lib/gamemanager'

gm = GameManager.new
board = gm.board
board.draw_board

p gm.gather_legal_moves('white')