# frozen_string_literal: true

require_relative '../dependencies'

module GameStateChecker

  def check?
    king = @board.find_king(@turn)
    @board.pieces_of_color(@board.opposing_color(@turn)).any? { |piece| piece.possible_moves(@board).include?(king.position) }
  end

  def checkmate?
    return false unless check?

    king = @board.find_king(@turn)
    king.possible_moves(@board).empty?
  end

  def stalemate?
    return false if check?

    @board.pieces_of_color(@turn).all? do |piece|
      piece.possible_moves(@board).empty?
    end
  end

  def draw?; end
end