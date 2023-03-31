# frozen_string_literal: true

require_relative 'dependencies'

class GameManager
  def initialize(board = Board.new, board_render = BoardRender.new(board))
    @board = board
    @board_render = board_render

    board.set_up_board if board.grid.flatten.compact.empty?
  end

  def draw_board
    @board_render.draw_board
  end

  def move_piece; end

  def is_check?; end

  def is_checkmate?; end

  def is_draw?; end

  def is_valid_move?; end

  def next_turn; end
end
