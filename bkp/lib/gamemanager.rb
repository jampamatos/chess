# frozen_string_literal: true

require_relative 'dependencies'
require 'pry-byebug'

START_ROW = { 'white' => 7, 'black' => 0 }.freeze

class GameManager
  attr_reader :active_turn
  attr_accessor :board, :white_player_name, :black_player_name

  def initialize(board = nil, active_pieces = nil, active_turn = nil, white_player_name = nil, black_player_name = nil)
    @board = board
    @active_pieces = active_pieces
    @active_turn = active_turn

    @white_player_name = white_player_name
    @black_player_name = black_player_name

    setup_game unless board
  end

  def setup_game
    @board = Board.new
    @active_pieces = board.active_pieces
    @active_turn = 'white'

    @white_player_name = nil
    @black_player_name = nil

    # create white pieces
    create_pieces('white', @active_pieces)

    # create black pieces
    create_pieces('black', @active_pieces)
  end

  def active_pieces
    @active_pieces = board.active_pieces
  end

  def draw_board(board = @board)
    board.draw_board
  end

  def set_piece(piece, position)
    @board.set_piece(piece, position)
  end

  def remove_piece(position)
    @board.remove_piece(position)
  end

  def promote_pawn(pawn, new_piece, new_pos)
    position = pawn.position
    remove_piece(position)
    set_piece(new_piece, new_pos)
    @active_pieces.delete_if { |_key, value| value == pawn }
    count = 1
    new_key = "promoted_#{new_piece.color}_#{new_piece.type.downcase}"
    while @active_pieces.key?(new_key + count.to_s)
      count += 1
    end
    @active_pieces[new_key + count.to_s] = new_piece
  end

  def play_turn; end

  def checkmate?
    
  end

  private

  def create_pieces(color, active_pieces)
    create_pawns(color, active_pieces)
    create_rooks(color, active_pieces)
    create_knights(color, active_pieces)
    create_bishops(color, active_pieces)
    create_queen(color, active_pieces)
    create_king(color, active_pieces)
  end

  def create_pawns(color, active_pieces)
    start_pawn_row = color == 'white' ? 6 : 1

    8.times do |i|
      position = [start_pawn_row, i]
      pawn = Pawn.new(color, position)
      set_piece(pawn, position)
      active_pieces["#{color}_pawn#{i + 1}"] = pawn
    end
  end

  def create_rooks(color, active_pieces)
    2.times do |i|
      rook = Rook.new(color.to_s)
      set_piece(rook, [START_ROW[color], i == 0 ? 0 : 7])
      active_pieces["#{color}_rook#{i + 1}"] = rook
    end
  end

  def create_knights(color, active_pieces)
    2.times do |i|
      knight = Knight.new(color.to_s)
      set_piece(knight, [START_ROW[color], i == 0 ? 1 : 6])
      active_pieces["#{color}_knight#{i + 1}"] = knight
    end
  end

  def create_bishops(color, active_pieces)
    2.times do |i|
      bishop = Bishop.new(color.to_s)
      set_piece(bishop, [START_ROW[color], i == 0 ? 2 : 5])
      active_pieces["#{color}_bishop#{i + 1}"] = bishop
    end
  end

  def create_queen(color, active_pieces)
    queen = Queen.new(color)
    set_piece(queen, [START_ROW[color], 3])
    active_pieces["#{color}_queen"] = queen
  end

  def create_king(color, active_pieces)
    king = King.new(color)
    set_piece(king, [START_ROW[color], 4])
    active_pieces["#{color}_king"] = king
  end

  def opposite_color
    @active_turn == 'white' ? 'black' : 'white'
  end

  def change_turn
    @active_turn = opposite_color
  end

  def find_king(color)
    @active_pieces.each do |_name, piece|
      return piece if piece.is_a?(King) && piece.color == color
    end
    nil
  end

  def gather_legal_moves(color)
    legal_moves = {}

    @active_pieces.each do |name, piece|
      next unless piece.color == color

      moves = piece.possible_moves(@board)
      legal_moves[name] = moves unless moves.empty?
    end

    legal_moves
  end
end
